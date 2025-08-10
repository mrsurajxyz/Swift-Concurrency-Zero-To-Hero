//
//  TaskDemoViewModel.swift
//  SwiftConcurrencyTutorial
//
//  Created by Haider Ashfaq on 10/08/2025.
//

import Foundation
import Observation

/// View model for **2.1 – Task**.
/// Demonstrates three essential Task patterns:
/// 1) A default Task that runs off the main actor and hops to main for UI updates.
/// 2) A Task confined to the main actor (`Task { @MainActor in ... }`) for end-to-end UI safety.
/// 3) A Task with explicit background priority to illustrate scheduling hints and inspection via `Task.currentPriority`.
///
/// At a staff level, focus on:
/// - **Lifecycle ownership**: `current` holds the running Task so we can cancel it (on re-tap or on disappear).
/// - **Actor correctness**: main-actor mutations only; off-main work uses `MainActor.run` to update UI.
/// - **Cooperative cancellation**: treat `CancellationError` as a non-failure outcome.
/// - **Teachability**: we record the thread (“main”/“background”) and `Task.currentPriority` for the learner to observe.
@Observable
final class TaskDemoViewModel {
    
    // MARK: - UI state
    /// Human-readable status (idle/loading/success/error/cancelled).
    var status: String = "Idle"
    
    /// Where the task body captured its thread at start ("main" or "background") for teaching purposes.
    var lastThread: String = "—"
    
    /// The priority observed inside the task (e.g., "userInitiated", "background").
    var lastPriority: String = "—"
    
    /// Whether a task is currently running (drives button enablement).
    var isRunning: Bool = false
    
    // MARK: - Internals
    private let client: NetworkClient
    
    /// Handle to the currently running Task. We cancel the old one in `willSet` to enforce "last request wins" and avoid stale completions.
    private var current: Task<Void, Never>? {
        willSet { current?.cancel() }
    }
    
    /// Create the VM with an injectable dependency for testability.
    init(client: NetworkClient = .init()) {
        self.client = client
    }
    
    /// Formats a `TaskPriority` to a stable teaching label.
    private func describe(_ p: TaskPriority) -> String {
        switch p {
        case .userInitiated: return "userInitiated"
        case .utility:       return "utility"
        case .background:    return "background"
        case .high:          return "high"
        case .medium:        return "medium"
        case .low:           return "low"
        default:             return "\(p)"
        }
    }
    
    // MARK: - Demos
    
    /// Starts a **default Task** (not main-actor isolated).
    ///
    /// Use this when you want to offload work from the UI actor but still “patch” UI state at safe points.
    /// Inside the task we *observe* runtime context (`Task.currentPriority`, `Thread.isMainThread`) to teach that a default `Task` body is **not** confined to the main actor. UI mutations are wrapped in
    /// `await MainActor.run { ... }` to preserve actor correctness. Cancellation is cooperative and surfaced
    /// as a non-failure state.
    ///
    /// - Parameter delaySeconds: Artificial delay to emulate work (default 3s for teaching; override in tests).
    @MainActor
    func runDefaultTask(delaySeconds: Double = 3.0) {
        guard !isRunning else { cancel(); return }
        isRunning = true
        status = "Default Task: fetching…"
        lastThread = "—"; lastPriority = "—"
        
        current = Task { [weak self] in
            guard let self else { return }
            let priority = Task.currentPriority
            let threadLabel = "non-main"

            do {
                let quote = try await self.client.fetchQuote(delaySeconds: delaySeconds)
                await MainActor.run {
                    self.lastPriority = self.describe(priority)
                    self.lastThread = threadLabel
                    self.status = "✅ \(quote)"
                    self.isRunning = false
                }
            } catch is CancellationError {
                await MainActor.run {
                    self.lastPriority = self.describe(priority)
                    self.lastThread = threadLabel
                    self.status = "Cancelled"
                    self.isRunning = false
                }
            } catch {
                await MainActor.run {
                    self.lastPriority = self.describe(priority)
                    self.lastThread = threadLabel
                    self.status = "❌ \(error.localizedDescription)"
                    self.isRunning = false
                }
            }
        }
    }
    
    /// Starts a Task whose **entire body runs on the main actor** (`Task { @MainActor in … }`).
    ///
    /// Choose this when the task is primarily **UI orchestration** (navigation, view-state changes, animations) or you need to interact with main-confined APIs (UIKit/AppKit, main-queue Core Data context).
    /// Because the body is main-actor isolated, you can mutate state **directly** without extra hops.
    ///
    /// - Parameter delaySeconds: Artificial delay to emulate work (default 3s for teaching; override in tests).
    @MainActor
    func runMainActorTask(delaySeconds: Double = 3.0) {
        guard !isRunning else { cancel(); return }
        isRunning = true
        status = "MainActor Task: fetching…"
        lastThread = "—"; lastPriority = "—"
        
        current = Task { @MainActor [weak self] in
            guard let self else { return }
            let priority = Task.currentPriority
         
            do {
                let quote = try await self.client.fetchQuote(delaySeconds: delaySeconds)
                self.lastPriority = self.describe(priority)
                self.lastThread = "main"
                self.status = "🟩 \(quote)"
                self.isRunning = false
            } catch is CancellationError {
                self.lastPriority = self.describe(priority)
                self.lastThread = "main"
                self.status = "Cancelled"
                self.isRunning = false
            } catch {
                self.lastPriority = self.describe(priority)
                self.lastThread = "main"
                self.status = "❌ \(error.localizedDescription)"
                self.isRunning = false
            }
        }
    }
    
    /// Starts a Task with **explicit `.background` priority** (scheduling hint).
    ///
    /// Use this for non-urgent work that shouldn’t compete with user-initiated interactions. We still update UI on the main actor at completion. Inside the task we log
    /// `Task.currentPriority` so learners can see the hint in action.
    ///
    /// - Parameter delaySeconds: Artificial delay to emulate work (default 3s for teaching; override in tests).
    @MainActor
    func runBackgroundPriorityTask(delaySeconds: Double = 3.0) {
        guard !isRunning else { cancel(); return }
        isRunning = true
        status = "Background-priority Task: fetching…"
        lastThread = "—"; lastPriority = "—"
        
        current = Task(priority: .background) { [weak self] in
            guard let self else { return }
            let priority = Task.currentPriority
            let isMain = false
            
            do {
                let quote = try await self.client.fetchQuote(delaySeconds: delaySeconds)
                await MainActor.run {
                    self.lastPriority = self.describe(priority)
                    self.lastThread = isMain ? "main" : "background"
                    self.status = "🟦 \(quote)"
                    self.isRunning = false
                }
            } catch is CancellationError {
                await MainActor.run {
                    self.lastPriority = self.describe(priority)
                    self.lastThread = isMain ? "main" : "background"
                    self.status = "Cancelled"
                    self.isRunning = false
                }
            } catch {
                await MainActor.run {
                    self.lastPriority = self.describe(priority)
                    self.lastThread = isMain ? "main" : "background"
                    self.status = "❌ \(error.localizedDescription)"
                    self.isRunning = false
                }
            }
        }
    }
    
    // MARK: - Cancellation
    
    /// Cancels any in-flight Task and publishes a **non-failure** cancel state.
    /// Use for user-initiated cancel (tap), view lifecycle (`onDisappear`),
    /// or when starting a newer request (last-writer-wins).
    @MainActor
    func cancel() {
        current?.cancel()
        isRunning = false
        status = "Cancelled"
    }
    
    // MARK: - Teaching log
    /// Ordered log of events so learners can see completion order.
    var logs: [String] = []
    
    @MainActor
    /// Async logger that hops to the main actor (so it's safe from anywhere).
    func logAsync(_ message: String) async {
        await MainActor.run {
            let ms = Int((Date().timeIntervalSince1970.truncatingRemainder(dividingBy: 1000)) * 1000)
            self.logs.append("[\(ms)ms] " + message)
        }
    }
    /// Starts two sibling tasks with different priorities to show that
    /// a later, higher-priority task can complete before an earlier background task.
    /// - Parameters:
    ///   - bgDelay: The background task's artificial delay (seconds).
    ///   - uiDelay: The user-initiated task's artificial delay (seconds).
    @MainActor
    func runPriorityRace(bgDelay: Double = 5.0, uiDelay: Double = 2.5) {
        guard !isRunning else { cancel(); return }
        isRunning = true
        status = "Priority race…"
        lastThread = "—"; lastPriority = "—"
        logs.removeAll()
        
        current = Task { [weak self] in
            guard let self else { return }
            
            // Background-priority child
            let bg = Task(priority: .background) { [weak self] in
                guard let self else { return }
                await self.logAsync("BG started (priority: \(Task.currentPriority))")
                do {
                    _ = try await self.client.fetchQuote(delaySeconds: bgDelay)
                    await self.logAsync("BG finished")
                } catch is CancellationError {
                    await self.logAsync("BG cancelled")
                } catch {
                    await self.logAsync("BG error: \(error.localizedDescription)")
                }
            }
            
            // Higher-priority child (user initiated)
            let ui = Task(priority: .userInitiated) { [weak self] in
                guard let self else { return }
                await self.logAsync("UI started (priority: \(Task.currentPriority))")
                do {
                    _ = try await self.client.fetchQuote(delaySeconds: uiDelay)
                    await self.logAsync("UI finished ✔︎ (should finish first)")
                    await MainActor.run {
                        self.status = "User-initiated finished before background"
                    }
                } catch is CancellationError {
                    await self.logAsync("UI cancelled")
                } catch {
                    await self.logAsync("UI error: \(error.localizedDescription)")
                }
            }
            
            // Await both children to keep things structured: no zombie tasks, errors surface here.
            _ = await (bg.result, ui.result)
            
            await MainActor.run {
                if !self.status.contains("finished before") {
                    self.status = "Priority race finished"
                }
                self.isRunning = false
            }
        }
    }
}
