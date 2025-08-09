//
//  AsyncLetDemoViewModel.swift
//  SwiftConcurrencyTutorialTests
//
//  Created by Haider Ashfaq on 09/08/2025.
//

import Observation

/// View model for **1.3 – async let**. It demonstrates **structured parallelism** by running two independent requests either sequentially (no overlap) or in
/// parallel (with `async let`).
///
/// The VM exposes:
/// - **Pure async methods** (`twoSequential`, `twoParallel`) — easy to unit test.
/// - **UI actions** (`runSequential`, `runParallel`, `cancel`) — handle timing,
///   cooperative cancellation, and main‑actor state updates.
@Observable
final class AsyncLetDemoViewModel {
    // MARK: - Outputs for the UI
    /// Result text for the first request.
    var resultA: String = "—"
    /// Result text for the second request.
    var resultB: String = "—"
    /// Current mode description (sequential / parallel / cancelled / error).
    var modeDescription: String = "Idle"
    /// Elapsed wall time formatted as seconds.
    var elapsed: String = "0.00s"
    /// Whether a run is in progress (used to toggle buttons and disable inputs).
    var isRunning: Bool = false

    // MARK: - Internals
    private let client: NetworkClient
    private var runningTask: Task<Void, Never>? { willSet { runningTask?.cancel() } }

    init(client: NetworkClient = .init()) { self.client = client }

    // MARK: - Pure async API (beginner‑friendly but staff‑grade behavior)

    /// Runs two async operations **back‑to‑back**.
    ///
    /// Why it’s sequential:
    /// - `await` **suspends** until the first call completes.
    /// - Only after `a` returns do we start `b`.
    /// - **No overlap** → total time ≈ `time(A) + time(B)`.
    ///
    /// Cancellation behavior:
    /// - If the task is cancelled during either await, a `CancellationError` is thrown
    ///   and we return early.
    ///
    /// - Parameters:
    ///   - aDelay: Artificial delay (seconds) for call A.
    ///   - bDelay: Artificial delay (seconds) for call B.
    /// - Returns: The two quotes, in completion order (A first, then B).
    func twoSequential(aDelay: Double, bDelay: Double) async throws -> (String, String) {
        let a = try await client.fetchQuote(delaySeconds: aDelay)
        let b = try await client.fetchQuote(delaySeconds: bDelay)
        return (a, b)
    }

    /// Runs two async operations **in parallel** using `async let`.
    ///
    /// Why it’s parallel:
    /// - `async let` **starts both immediately**; neither awaits the other.
    /// - Work **overlaps**; we await both results later.
    /// - Total time ≈ `max(time(A), time(B))`.
    ///
    /// Ordering & safety:
    /// - The tuple `(a, b)` preserves **binding order**, not completion order.
    /// - If awaiting one throws, the other in‑flight child is **cancelled automatically**
    ///   by structured concurrency.
    ///
    /// - Parameters:
    ///   - aDelay: Artificial delay (seconds) for call A.
    ///   - bDelay: Artificial delay (seconds) for call B.
    /// - Returns: The two quotes matching binding order `(A, B)`.
    func twoParallel(aDelay: Double, bDelay: Double) async throws -> (String, String) {
        async let a = client.fetchQuote(delaySeconds: aDelay)
        async let b = client.fetchQuote(delaySeconds: bDelay)
        return try await (a, b)
    }

    // MARK: - UI actions (stateful; main‑actor mutations)

    /// Runs the sequential comparison and updates UI state. Cancels any prior run.
    @MainActor
    func runSequential(aDelay: Double = 1.0, bDelay: Double = 1.0) {
        guard !isRunning else { cancel(); return }
        isRunning = true
        modeDescription = "Sequential (await then await)"
        resultA = "…"; resultB = "…"; elapsed = "—"

        runningTask = Task { [weak self] in
            guard let self else { return }
            let clock = ContinuousClock(); let start = clock.now
            do {
                let (a, b) = try await self.twoSequential(aDelay: aDelay, bDelay: bDelay)
                let seconds = start.duration(to: clock.now).secondsDouble
                await MainActor.run {
                    self.resultA = a
                    self.resultB = b
                    self.elapsed = String(format: "%.2fs", seconds)
                    self.isRunning = false
                }
            } catch is CancellationError {
                await MainActor.run { self.modeDescription = "Cancelled"; self.isRunning = false }
            } catch {
                await MainActor.run { self.modeDescription = "Error: \(error.localizedDescription)"; self.isRunning = false }
            }
        }
    }

    /// Runs the parallel comparison and updates UI state. Cancels any prior run.
    @MainActor
    func runParallel(aDelay: Double = 1.0, bDelay: Double = 1.0) {
        guard !isRunning else { cancel(); return }
        isRunning = true
        modeDescription = "Parallel (async let)"
        resultA = "…"; resultB = "…"; elapsed = "—"

        runningTask = Task { [weak self] in
            guard let self else { return }
            let clock = ContinuousClock(); let start = clock.now
            do {
                let (a, b) = try await self.twoParallel(aDelay: aDelay, bDelay: bDelay)
                let seconds = start.duration(to: clock.now).secondsDouble
                await MainActor.run {
                    self.resultA = a
                    self.resultB = b
                    self.elapsed = String(format: "%.2fs", seconds)
                    self.isRunning = false
                }
            } catch is CancellationError {
                await MainActor.run { self.modeDescription = "Cancelled"; self.isRunning = false }
            } catch {
                await MainActor.run { self.modeDescription = "Error: \(error.localizedDescription)"; self.isRunning = false }
            }
        }
    }

    /// Cancels any in-flight comparison and updates UI state.
    @MainActor
    func cancel() {
        runningTask?.cancel()
        isRunning = false
        modeDescription = "Cancelled"
    }
}
