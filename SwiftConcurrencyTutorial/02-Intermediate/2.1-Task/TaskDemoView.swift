//
//  TaskDemoView.swift
//  SwiftConcurrencyTutorial
//
//  Created by Haider Ashfaq on 10/08/2025.
//

import SwiftUI

/// SwiftUI demo for **2.1 – Task**.
/// Shows three core patterns:
/// - A default Task that runs off the main actor and hops to main for UI updates.
/// - A Task whose entire body runs on the main actor (`Task { @MainActor in ... }`).
/// - A Task launched with explicit background priority.
/// The view binds to `TaskDemoViewModel` and provides a simple control panel
/// to start/cancel work while surfacing thread/priority for teaching.
struct TaskDemoView: View {
    @State private var vm = TaskDemoViewModel()
    
    var body: some View {
        Form {
            Section("Status") {
                Text(vm.status)
                HStack {
                    LabeledContent("Thread") { Text(vm.lastThread) }
                    LabeledContent("Priority") { Text(vm.lastPriority) }
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
            
            Section("Run") {
                Button(vm.isRunning ? "Cancel" : "Default Task") {
                    vm.isRunning ? vm.cancel() : vm.runDefaultTask()
                }
                .buttonStyle(.borderedProminent)
                
                Button("MainActor Task") {
                    vm.runMainActorTask()
                }
                .buttonStyle(.bordered)
                .disabled(vm.isRunning)
                
                Button("Background Priority Task") {
                    vm.runBackgroundPriorityTask()
                }
                .buttonStyle(.bordered)
                .disabled(vm.isRunning)
            }
            
            Section("Notes") {
                Text(
"""
• Default Task inherits priority/cancellation from the parent task.
• MainActor Task keeps execution on the UI actor end-to-end.
• Background-priority Task hints the scheduler to deprioritize work.
"""
                )
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
            
            Section("Priority race (background vs user-initiated)") {
                Button(vm.isRunning ? "Cancel" : "Start Race") {
                    vm.isRunning ? vm.cancel() : vm.runPriorityRace()
                }
                .buttonStyle(.borderedProminent)
                
                // Small, readable event log
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(Array(vm.logs.enumerated()), id: \.offset) { _, line in
                        Text(line).font(.caption.monospaced())
                    }
                    if vm.logs.isEmpty {
                        Text("Tap “Start Race” — the user-initiated task should finish before the background one.")
                            .font(.footnote).foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("2.1 Task")
        .onDisappear { vm.cancel() }
    }
}

#if DEBUG
#Preview("2.1 Task") { NavigationStack { TaskDemoView() } }
#endif
