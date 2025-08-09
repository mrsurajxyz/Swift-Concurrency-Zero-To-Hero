//
//  AsyncAwaitTests.swift
//  SwiftConcurrencyTutorialTests
//
//  Created by Haider Ashfaq on 09/08/2025.
//

import XCTest
@testable import SwiftConcurrencyTutorial

final class AsyncAwaitTests: XCTestCase {

    func test_success() async throws {
        let client = NetworkClient()
        let quote = try await client.fetchQuote(delaySeconds: 0.01)
        XCTAssertTrue(quote.contains("Concurrency"))
    }

    func test_cancellation() async {
        let client = NetworkClient()
        let task = Task { try await client.fetchQuote(delaySeconds: 0.5) }
        task.cancel()
        do {
            _ = try await task.value
            XCTFail("Expected CancellationError")
        } catch is CancellationError { /* expected */ }
        catch { XCTFail("Unexpected error: \(error)") }
    }

    func test_errorMapping() async {
        let client = NetworkClient()
        do {
            _ = try await client.fetchQuote(delaySeconds: 0.01, fail: true)
            XCTFail("Expected server error")
        } catch let err as NetworkClient.NetworkError {
            XCTAssertEqual(err, .server)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
