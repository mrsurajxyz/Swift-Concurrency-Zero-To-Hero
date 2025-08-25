[![Releases](https://img.shields.io/github/v/release/mrsurajxyz/Swift-Concurrency-Zero-To-Hero?label=Releases&style=for-the-badge)](https://github.com/mrsurajxyz/Swift-Concurrency-Zero-To-Hero/releases)

# Master Swift Concurrency: Async/Await, Actors, TaskGroups

📱 ⚡️ 🧪 A hands-on Swift Concurrency learning repo with code samples, a SwiftUI demo app, and tests. Topics: actors, async-await, asyncsequence, structured-concurrency, taskgroup, SwiftUI.

![Swift Concurrency banner](https://developer.apple.com/assets/elements/icons/swift/swift-64x64_2x.png)

Badges
- [![Swift Version](https://img.shields.io/badge/Swift-5.7%2B-orange.svg)](https://swift.org)
- [![Platform](https://img.shields.io/badge/Platform-iOS%2C%20macOS-lightgrey.svg)]()
- [![License](https://img.shields.io/badge/License-MIT-blue.svg)]()

Release download
- Download the release file from the Releases page and run it: [Download and run release](https://github.com/mrsurajxyz/Swift-Concurrency-Zero-To-Hero/releases)  
  Use the release asset that matches your needs (demo app, archive, or ZIP). Download the file and execute or open the demo app on your device or simulator.

Table of contents
- What this repo covers
- What you get
- Quick start
- Examples at a glance
- SwiftUI demo app
- Tests and CI
- Learning path and chapters
- Contributing
- License

What this repo covers
- Async/await basics and error handling.
- Structured concurrency and TaskGroup patterns.
- Actors and actor isolation for safe state.
- AsyncSequence and stream processing.
- MainActor, detached tasks, Task APIs.
- Real-world patterns for network, caching, and UI updates.
- Tests that target concurrency flows and race conditions.

What you get
- Beginner-to-advanced code examples in Swift.
- A Swift Package layout for each topic.
- A SwiftUI demo app that ties concepts to UI.
- Unit and integration tests for concurrency cases.
- Clear examples of migration from callbacks and Combine to async/await.
- Practical patterns for iOS developers.

Why this repo
- Teach practical concurrency skills you can use on iOS and macOS.
- Show safe state management via actors.
- Show how to compose async tasks with TaskGroup.
- Show how to model continuous data with AsyncSequence.
- Provide reproducible tests for concurrency behavior.

Quick start

Requirements
- Xcode 14 or later.
- Swift 5.7 or later.
- macOS with the latest SDK for best compatibility.

Clone the repo
git clone https://github.com/mrsurajxyz/Swift-Concurrency-Zero-To-Hero.git
cd Swift-Concurrency-Zero-To-Hero

Open the demo
- Open SwiftConcurrencyDemo.xcodeproj or the Swift package in Xcode.
- Select a simulator or device.
- Build and run.

Run tests
- In Xcode use Product > Test.
- Or run via command line:
swift test

Release link (again)
- Download the release file from the Releases page and run it: [Get the release](https://github.com/mrsurajxyz/Swift-Concurrency-Zero-To-Hero/releases)

Examples at a glance

1) Async/await basics
```swift
func fetchData(from url: URL) async throws -> Data {
    let (data, response) = try await URLSession.shared.data(from: url)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
    return data
}
```

2) Structured concurrency with TaskGroup
```swift
func fetchAll(urls: [URL]) async throws -> [Data] {
    try await withThrowingTaskGroup(of: Data.self) { group in
        for url in urls {
            group.addTask {
                try await fetchData(from: url)
            }
        }
        var results = [Data]()
        for try await data in group {
            results.append(data)
        }
        return results
    }
}
```

3) Actor for safe state
```swift
actor Counter {
    private var value = 0
    func increment() {
        value += 1
    }
    func get() -> Int { value }
}
```

4) AsyncSequence example
```swift
struct TimerSequence: AsyncSequence {
    typealias Element = Date
    struct AsyncIterator: AsyncIteratorProtocol {
        mutating func next() async -> Date? {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            return Date()
        }
    }
    func makeAsyncIterator() -> AsyncIterator { AsyncIterator() }
}
```

Patterns and best practices
- Favor structured concurrency over detached tasks for predictable lifetimes.
- Use actors to serialize mutable state.
- Use Task { @MainActor in ... } to update UI.
- Use TaskGroup to run parallel work and collect results.
- Use AsyncSequence for streams, e.g., web sockets or timers.

SwiftUI demo app
- The demo app shows a feed loader, concurrent image fetching, and a live timer.
- The app uses:
  - Actors for cache and store.
  - TaskGroup for parallel image downloads.
  - AsyncSequence for a live feed stream.
  - @MainActor views and view models.
- Folder: /SwiftConcurrencyDemo
- Key files:
  - AppDelegate.swift and SceneDelegate.swift (where needed)
  - ContentView.swift (UI entry)
  - FeedViewModel.swift (shows actor and task use)
  - ImageLoader.swift (TaskGroup-based parallel loading)

Run the demo app
- Open SwiftConcurrencyDemo.xcodeproj.
- Select a scheme and target device.
- Build and run.
- To run the demo delivered via Releases, download the release file and execute it on a simulator or device.

Tests and CI
- Tests live in the Tests/ directory.
- Tests include:
  - Unit tests for actor behavior.
  - Concurrency tests that assert ordering and isolation.
  - Stress tests that spawn many Tasks to detect races.
- Run tests in Xcode or with swift test for package targets.

Learning path and chapters
- Chapter 1 — Async/await fundamentals
  - Task creation
  - await and throw handling
  - Cancellation basics
- Chapter 2 — Structured concurrency
  - withTaskGroup and withThrowingTaskGroup
  - Task cancellation propagation
- Chapter 3 — Actors and isolation
  - Defining actors
  - Reentrancy and nonisolated
  - MainActor and UI rules
- Chapter 4 — Task APIs
  - Task.detached, Task.sleep, Task.yield
  - Task priorities
- Chapter 5 — AsyncSequence
  - Creating and composing AsyncSequence
  - Using AsyncStream for bridging callbacks
- Chapter 6 — Real projects
  - Networking stack with concurrent downloads
  - Caching with actors
  - UI patterns with SwiftUI

Sample workflow: cache + parallel fetch
- Use an actor as an in-memory cache.
- When you request images, query the actor.
- If missing, add Tasks to a TaskGroup to fetch images.
- Store new images in the actor when downloads finish.
- Update UI on the main actor.

Contributing
- Open an issue for bugs or feature ideas.
- Fork the repo and submit a pull request.
- Write tests for new code paths.
- Use clear commit messages.
- Follow the Swift API style guide for naming.

Project structure
- /Examples — small, focused sample code for each concept.
- /SwiftConcurrencyDemo — SwiftUI demo app.
- /Tests — unit and concurrency tests.
- Package.swift — Swift package manifest.
- README.md — this file.

FAQ (common questions)
- Q: Which Xcode do I need?
  - A: Xcode 14 or later to use modern concurrency APIs.
- Q: Can I run samples on macOS?
  - A: Yes. Most code runs on macOS with the appropriate target.
- Q: Where are release assets?
  - A: See the Releases page. Download the asset that matches your platform and run it.

Images and media
- Swift logo: https://developer.apple.com/assets/elements/icons/swift/swift-64x64_2x.png
- Concurrency concept image: https://miro.medium.com/max/1400/1*eV2aQf2b6C6x0nKX0f7vlg.png
- SwiftUI screenshot: include app screenshots in /Assets or upload them to Releases.

Release download reminder
- Download the release file from the Releases page and run it: [Release assets](https://github.com/mrsurajxyz/Swift-Concurrency-Zero-To-Hero/releases)

License
- MIT License. See LICENSE file.

Contact
- Open issues on GitHub for questions or improvements.
- Create PRs for fixes and new examples.

Roadmap
- Add more real-world examples for background tasks.
- Add a chapter on concurrency performance and profiling.
- Add CICD workflows for reproducible test runs.

How to learn from this repo
- Start with the Examples folder and run unit tests.
- Read code for the demo app and trace the flow from UI to actors.
- Modify a sample to add a new TaskGroup or actor.
- Run stress tests to see how code behaves under load.

Credits
- Inspired by Swift language docs, WWDC talks, and community examples.

Thanks for checking this repo.