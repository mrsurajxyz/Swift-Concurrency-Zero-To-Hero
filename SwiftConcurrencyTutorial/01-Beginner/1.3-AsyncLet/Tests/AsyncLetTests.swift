//
//  AsyncLetTests.swift
//  SwiftConcurrencyTutorialTests
//
//  Created by Haider Ashfaq on 09/08/2025.
//

import XCTest
@testable import SwiftConcurrencyTutorial

/// Tests for 1.3 async let — via the ViewModel’s pure methods.
final class AsyncLetTests: XCTestCase {

    func test_parallel_faster_than_sequential_under_equal_delays() async throws {
        let vm = AsyncLetDemoViewModel()
        let a = 0.30, b = 0.30

        let clock = ContinuousClock()

        var t0 = clock.now
        _ = try await vm.twoSequential(aDelay: a, bDelay: b)
        let seq = t0.duration(to: clock.now).secondsDouble

        t0 = clock.now
        _ = try await vm.twoParallel(aDelay: a, bDelay: b)
        let par = t0.duration(to: clock.now).secondsDouble

        // Sequential ≈ 0.60s, Parallel ≈ 0.30s. Allow margin for CI noise.
        XCTAssertLessThan(par, seq * 0.8, "Parallel should be significantly faster than sequential")
    }

    func test_parallel_duration_near_max_delay_when_different() async throws {
        let vm = AsyncLetDemoViewModel()
        let a = 0.10, b = 0.40

        let clock = ContinuousClock()
        let t0 = clock.now
        _ = try await vm.twoParallel(aDelay: a, bDelay: b)
        let par = t0.duration(to: clock.now).secondsDouble

        // Expect ~0.40s (near the slower branch), definitely < sum (0.50s).
        XCTAssertGreaterThanOrEqual(par, 0.35, "Should be near the slower branch")
        XCTAssertLessThan(par, 0.60, "Should be less than the sum of both delays")
    }

    func test_cancel_updates_state() async throws {
        let vm = AsyncLetDemoViewModel()

        // Start a run on the main actor.
        await MainActor.run { vm.runParallel(aDelay: 0.5, bDelay: 0.5) }

        // Give the background task a tick to start.
        try? await Task.sleep(nanoseconds: 50_000_000)

        // Cancel and verify UI state.
        await MainActor.run { vm.cancel() }
        let isRunning = await MainActor.run { vm.isRunning }
        let mode = await MainActor.run { vm.modeDescription }

        XCTAssertFalse(isRunning)
        XCTAssertEqual(mode, "Cancelled")
    }
}

