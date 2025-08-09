//
//  1.2-NetworkClient.swift
//  SwiftConcurrencyTutorial
//
//  Created by Haider Ashfaq on 09/08/2025.
//

import Foundation

/// A tiny, deterministic async client used to demonstrate suspension, cooperative cancellation, and error mapping.
///
/// This is intentionally minimal so the concurre   ncy behavior is the focus during learning and tests.
struct NetworkClient {
    
    /// Errors that can be emitted by `NetworkClient`.
    enum NetworkError: Error, Equatable {
        /// Simulates a server-side failure (e.g., 5xx).
        case server
        /// Included to show how you might represent decoding failures.
        case decoding
    }
    
    /// Simulates an async network call with optional failure and delay.
    /// The method performs **cooperative cancellation checks** both
    /// before and after suspension to ensure timely task cancellation.
    ///
    /// - Parameters:
    ///   - delaySeconds: The artificial latency before returning, in seconds. Defaults to 3.0s to make suspension visible during teaching.
    ///   - fail: When `true`, throws ``NetworkError/server`` after delay.
    /// - Returns: A sample quote string.
    /// - Throws: ``NetworkError`` for simulated server issues, or `CancellationError` if the task is cancelled.
    /// - Important: Always prefer **cooperative cancellation** for async work. Using `Task.checkCancellation()` around suspension points
    ///              prevents stale work from completing.
    func fetchQuote(
        delaySeconds: Double = 3.0,
        fail: Bool = false
    ) async throws -> String {
        print("📡 [NetworkClient] Starting fetchQuote — delay: \(delaySeconds)s fail: \(fail)")
        
        // Check for cancellation **before** doing any work.
        try Task.checkCancellation()
        print("✅ [NetworkClient] Passed pre-work cancellation check")
        
        // Simulate network latency (this is a suspension point).
        try await Task.sleep(for: .seconds(delaySeconds))
        print("⏳ [NetworkClient] Finished artificial delay of \(delaySeconds)s")
        
        // Check for cancellation **after** suspension to cut off stale completions.
        try Task.checkCancellation()
        print("✅ [NetworkClient] Passed post-delay cancellation check")
        
        if fail {
            print("❌ [NetworkClient] Simulating server error")
            throw NetworkError.server
        }
        
        print("🎉 [NetworkClient] Returning success quote")
        return "Concurrency turns waiting into doing."
    }
}
