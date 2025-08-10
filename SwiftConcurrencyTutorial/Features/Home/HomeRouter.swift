//
//  HomeRouter.swift
//  SwiftConcurrencyTutorialTests
//
//  Created by Haider Ashfaq on 09/08/2025.
//

import SwiftUI

enum TopicDestination: Hashable {
    // Beginner
    case whatIsSwiftConcurrency
    case asyncAwaitBasics
    case asyncLet
    
    // Intermediate
    case task
    case taskGroup
    case detachedTasks
    case cancellation
    
    // Advanced
    case actors
    case asyncSequences
    case mixingWithCombine
    case performanceAndPitfalls
}

@ViewBuilder
func destinationView(for dest: TopicDestination) -> some View {
    switch dest {
    case .whatIsSwiftConcurrency:
        MarkdownTopicView(filename: "01-Beginner/1.1-WhatIsSwiftConcurrency")
    case .asyncAwaitBasics:
        AsyncAwaitDemoView()
    case .asyncLet:
        AsyncLetDemoView()
    case .task:
        TaskDemoView()
    default:
        ComingSoonView(title: "Coming soon")
    }
}

/// Minimal placeholder while demos are built out.
struct ComingSoonView: View {
    let title: String
    var body: some View {
        VStack(spacing: 8) {
            Text(title).font(.title3).bold()
            Text("Demo coming soon. Follow the README folder path.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

/// Optional: a simple markdown viewer for 1.1 (replace with a richer renderer later).
struct MarkdownTopicView: View {
    let filename: String
    
    var body: some View {
        ScrollView { Text("Open README: \(filename).md") }.padding()
    }
}
