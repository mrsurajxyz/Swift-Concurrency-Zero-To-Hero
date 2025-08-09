//
//  AsyncLetDemoView.swift
//  SwiftConcurrencyTutorialTests
//
//  Created by Haider Ashfaq on 09/08/2025.
//

import SwiftUI

/// UI for **1.3 – async let**.
/// Lets you run two requests either **sequentially** or in **parallel (async let)** and compare the elapsed time. Uses an injectable `@Observable` view model.
struct AsyncLetDemoView: View {
    @State private var vm: AsyncLetDemoViewModel

    /// Default + injectable init (clean for production and previews).
    init(vm: AsyncLetDemoViewModel = .init()) {
        _vm = State(initialValue: vm)
    }

    var body: some View {
        Form {
            Section("Mode") {
                Text(vm.modeDescription)
                Text("Elapsed: \(vm.elapsed)")
                    .font(.system(.body, design: .monospaced))
            }

            Section("Results") {
                LabeledContent("A") { Text(vm.resultA) }
                LabeledContent("B") { Text(vm.resultB) }
            }

            Section("Actions") {
                HStack(spacing: 12) {
                    Button(vm.isRunning ? "Cancel" : "Run Sequential") {
                        vm.isRunning ? vm.cancel() : vm.runSequential(aDelay: 1.0, bDelay: 1.0)
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Run Parallel") {
                        vm.runParallel(aDelay: 1.0, bDelay: 1.0)
                    }
                    .buttonStyle(.bordered)
                    .disabled(vm.isRunning)
                }
            }

            Section("Teaching Notes") {
                Text("Sequential time ≈ aDelay + bDelay. Parallel time ≈ max(aDelay, bDelay).")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("1.3 async let")
        .onDisappear {
            vm.cancel()
        }
    }
}

#if DEBUG
// Preview stubs keep UI deterministic and fast.
extension AsyncLetDemoViewModel {
    static func stub(
        mode: String = "Parallel (async let)",
        elapsed: String = "1.01s",
        a: String = "Quote A",
        b: String = "Quote B",
        running: Bool = false
    ) -> AsyncLetDemoViewModel {
        let vm = AsyncLetDemoViewModel()
        vm.modeDescription = mode
        vm.elapsed = elapsed
        vm.resultA = a
        vm.resultB = b
        vm.isRunning = running
        return vm
    }
}

#Preview("Completed Parallel") {
    NavigationStack { AsyncLetDemoView(vm: .stub()) }
}
#endif

