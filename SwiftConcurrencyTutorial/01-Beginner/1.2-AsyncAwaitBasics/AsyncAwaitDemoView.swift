//
//  AsyncAwaitDemoView.swift
//  SwiftConcurrencyTutorialTests
//
//  Created by Haider Ashfaq on 09/08/2025.
//

import SwiftUI

/// A SwiftUI view demonstrating async/await and cooperative cancellation.
struct AsyncAwaitDemoView: View {
    @State private var vm: AsyncAwaitDemoViewModel
    
    /// One init that supports both default and injection.
    init(vm: AsyncAwaitDemoViewModel = .init()) {
        _vm = State(initialValue: vm)
    }

    var body: some View {
        VStack(spacing: 16) {
            Text(vm.text)
                .multilineTextAlignment(.center)

            HStack {
                Button(vm.isLoading ? "Cancel" : "Fetch Quote") { vm.fetch() }
                    .buttonStyle(.borderedProminent)

                Button("Fail Once") { vm.fetch(fail: true) }
                    .buttonStyle(.bordered)
                    .disabled(vm.isLoading)
            }
        }
        .padding()
        .navigationTitle("async/await")
        .onDisappear {
            vm.cancel()
        }
    }
}

#if DEBUG

private extension AsyncAwaitDemoViewModel {
    static func stub(text: String, isLoading: Bool = false) -> AsyncAwaitDemoViewModel {
        let vm = AsyncAwaitDemoViewModel()
        vm.text = text
        vm.isLoading = isLoading
        return vm
    }
}

#Preview("Loading (fast)") {
    NavigationStack {
        AsyncAwaitDemoView(vm: {
            let vm = AsyncAwaitDemoViewModel.stub(text: "Stub Fetch Complete")
            
            // kick off a fast fetch on appear
            Task { await vm.fetch() }
            return vm
        }())
    }
}
#endif
