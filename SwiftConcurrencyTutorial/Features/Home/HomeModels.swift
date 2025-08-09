//
//  HomeModels.swift
//  SwiftConcurrencyTutorialTests
//
//  Created by Haider Ashfaq on 09/08/2025.
//

import Foundation

/// Course sections matching the README learning path.
enum LearningSection: String, CaseIterable, Identifiable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    var id: String { rawValue }
}

/// A single topic row under a `LearningSection`.
struct TopicItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let destination: TopicDestination
}
