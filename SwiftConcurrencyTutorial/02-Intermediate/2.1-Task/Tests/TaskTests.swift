//
//  TaskTests.swift
//  SwiftConcurrencyTutorial
//
//  Created by Haider Ashfaq on 10/08/2025.
//

import XCTest
@testable import SwiftConcurrencyTutorial

/// Tests for 2.1 – Task.
/// Runs on the main actor for cleaner calls to @MainActor APIs.
@MainActor
final class TaskTests: XCTestCase {

    func test_defaultTask_completesSuccessfully_fast() async throws {
        let vm = TaskDemoViewModel()
        vm.runDefaultTask(delaySeconds: 0.01)

        try? await Task.sleep(for: .seconds(0.05))

        XCTAssertFalse(vm.isRunning, "VM should not be running after completion.")
        XCTAssertTrue(vm.status.contains("Concurrency"), "Expected success text in status.")
        XCTAssertFalse(vm.lastThread.isEmpty || vm.lastThread == "—",
                       "Should record a thread label for teaching.")
    }

    func test_mainActorTask_runsOnMainActor() async throws {
        let vm = TaskDemoViewModel()
        vm.runMainActorTask(delaySeconds: 0.01)

        try? await Task.sleep(for: .seconds(0.05))

        XCTAssertFalse(vm.isRunning)
        XCTAssertEqual(vm.lastThread.lowercased(), "main",
                       "MainActor Task should report main context.")
    }

    func test_backgroundPriorityTask_recordsPriority() async throws {
        let vm = TaskDemoViewModel()
        vm.runBackgroundPriorityTask(delaySeconds: 0.01)

        try? await Task.sleep(for: .seconds(0.05))

        XCTAssertEqual(vm.lastPriority.lowercased(), "background",
                       "Should record background priority.")
    }

    func test_cancellation_updatesStatus() async throws {
        let vm = TaskDemoViewModel()
        vm.runDefaultTask(delaySeconds: 0.5) // long enough to cancel mid-flight

        try? await Task.sleep(for: .seconds(0.05)) // let it start
        vm.cancel()

        try? await Task.sleep(for: .seconds(0.02))

        XCTAssertFalse(vm.isRunning)
        XCTAssertTrue(vm.status.lowercased().contains("cancelled"),
                      "Expected 'Cancelled' in status after cancel.")
    }
}
