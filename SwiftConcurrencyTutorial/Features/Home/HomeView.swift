//
//  HomeView.swift
//  SwiftConcurrencyTutorial
//
//  Created by Haider Ashfaq on 09/08/2025.
//

import SwiftUI

/// The course-style Home that mirrors the README learning path.
/// Sections: Beginner, Intermediate, Advanced. Each row routes to a typed destination.
struct HomeView: View {
    /// Static catalog mapping sections to their topic items.
    private let catalog: [(LearningSection, [TopicItem])] = [
        (
            .beginner,
            [
                TopicItem(title: "What is Swift Concurrency?",
                          subtitle: "The problem it solves; vs GCD & callbacks",
                          destination: .whatIsSwiftConcurrency),
                TopicItem(title: "async & await",
                          subtitle: "Suspension points; sequential async calls",
                          destination: .asyncAwaitBasics),
                TopicItem(title: "async let",
                          subtitle: "Structured parallelism in a single scope",
                          destination: .asyncLet)
            ]
        ),
        (
            .intermediate,
            [
                TopicItem(title: "Task",
                          subtitle: "Run async work in a new context; main vs background",
                          destination: .task),
                TopicItem(title: "TaskGroup",
                          subtitle: "Parallelize multiple tasks and collect results",
                          destination: .taskGroup),
                TopicItem(title: "Detached Tasks",
                          subtitle: "When to use (and when not to)",
                          destination: .detachedTasks),
                TopicItem(title: "Cancellation",
                          subtitle: "Cooperative checks; lifecycle & user-driven",
                          destination: .cancellation)
            ]
        ),
        (
            .advanced,
            [
                TopicItem(title: "Actors",
                          subtitle: "Protecting mutable state; nonisolated APIs",
                          destination: .actors),
                TopicItem(title: "Async Sequences",
                          subtitle: "AsyncSequence & AsyncStream; consuming with for-await",
                          destination: .asyncSequences),
                TopicItem(title: "Mixing with Combine",
                          subtitle: "Bridging async code and publishers",
                          destination: .mixingWithCombine),
                TopicItem(title: "Performance & Pitfalls",
                          subtitle: "Priority inversions; structured concurrency costs",
                          destination: .performanceAndPitfalls)
            ]
        )
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(catalog, id: \.0.id) { section, items in
                    Section(section.rawValue) {
                        ForEach(items) { item in
                            NavigationLink(value: item.destination) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.title).font(.headline)
                                    Text(item.subtitle)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Swift Concurrency Tutorial")
            .navigationDestination(for: TopicDestination.self) { dest in
                destinationView(for: dest)
            }
        }
    }
}

#if DEBUG
#Preview("Home — Course-style") {
    NavigationStack { HomeView() }
}
#endif
