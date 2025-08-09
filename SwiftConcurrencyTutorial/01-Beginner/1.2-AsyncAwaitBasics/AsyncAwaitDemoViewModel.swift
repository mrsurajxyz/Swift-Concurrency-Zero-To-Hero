//
//  AsyncAwaitDemoViewModel.swift
//  SwiftConcurrencyTutorialTests
//
//  Created by Haider Ashfaq on 09/08/2025.
//

import Observation

/// View model for the async/await demo, implementing cooperative cancellation and distinct UI states.
@Observable
final class AsyncAwaitDemoViewModel {
    /// The current status or result text to display.
    var text: String = "Tap to fetch…"
    
    /// Whether a fetch operation is currently running.
    var isLoading = false

    /// The network client used to perform fetches.
    private let client: NetworkClient
    
    /// The currently active task, if any. Cancels any in-flight task before starting a new one.
    private var currentTask: Task<Void, Never>? {
        willSet { currentTask?.cancel() }
    }

    /// Creates a new view model instance.
    /// - Parameter client: The `NetworkClient` to use. Defaults to a new instance.
    init(client: NetworkClient = .init()) {
        self.client = client
    }

    @MainActor
    /// Starts fetching a quote. If already loading, cancels the current operation.
    /// - Parameter fail: Pass `true` to simulate a server error.
    func fetch(fail: Bool = false) {
        guard !isLoading else { cancel() ; return }
        isLoading = true
        text = "Loading…"
        currentTask = Task { [weak self] in
            guard let self else { return }
            do {
                let quote = try await client.fetchQuote(fail: fail)
                self.text = "“\(quote)”"
            } catch is CancellationError {
                self.text = "Cancelled."
            } catch {
                self.text = "Error: \(error.localizedDescription)"
            }
            self.isLoading = false
        }
    }
    
    @MainActor
    /// Cancels the current task, if any, and updates the UI state to reflect cancellation.
    func cancel() {
        currentTask?.cancel()
        isLoading = false
        text = "Cancelled."
    }
}
