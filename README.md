# 🚀 Swift Concurrency — From Beginner to Advanced  

<p align="center">
<img width="1536" height="1024" alt="ChatGPT Image Aug 9, 2025, 07_25_53 PM" src="https://github.com/user-attachments/assets/200b88e7-a33b-4a35-b9a5-9196c6da9f6a" />
</p>

A complete, hands-on journey through **Swift Concurrency** for iOS engineers — starting from the basics of `async/await` and building up to advanced concurrency patterns, real-world architecture, and performance best practices.  

This open-source project is built with **SwiftUI** and **Xcode Previews** to make every concept visual and interactive.  
Think of it as your free, code-first alternative to expensive courses with practical examples and best practices from real production apps.  

---

## ✨ What You’ll Learn

- ✅ `async/await` fundamentals  
- ✅ Structured concurrency with `Task` & `TaskGroup`  
- ✅ Background work with `Task.detached`  
- ✅ Data streaming with `AsyncSequence` & `AsyncStream`  
- ✅ Protecting state with `actor` & `nonisolated`  
- ✅ Cancellation & cooperative tasks  
- ✅ Mixing async code with Combine  
- ✅ Performance tuning & avoiding pitfalls  

---

## 🧩 Who Is This For?

This repo is perfect for:  

- iOS engineers new to Swift Concurrency  
- Developers migrating from completion handlers or Combine  
- Senior engineers mentoring teams on async patterns  
- Anyone preparing for technical interviews or code challenges  

---

## 🗂 Project Structure  

```
SwiftConcurrencyTutorial/
├─ 01-Beginner/
│ ├─ 1.1-WhatIsSwiftConcurrency.md
│ ├─ 1.2-AsyncAwaitBasics/
│ │ ├─ AsyncAwaitBasics.swift // Playground/demo code
│ │ ├─ AsyncAwaitDemoViewModel.swift // @Observable VM for demo
│ │ ├─ AsyncAwaitDemoView.swift // SwiftUI demo UI
│ │ └─ Tests/
│ ├─ 1.3-AsyncLet/
│ │ ├─ AsyncLetDemo.swift
│ │ ├─ AsyncLetDemoViewModel.swift
│ │ ├─ AsyncLetDemoView.swift
│ │ └─ Tests/
│
├─ 02-Intermediate/
│ ├─ 2.1-Task/
│ │ ├─ TaskDemo.swift
│ │ ├─ TaskDemoViewModel.swift
│ │ ├─ TaskDemoView.swift
│ │ └─ Tests/
│ ├─ 2.2-TaskGroup/
│ │ ├─ TaskGroupDemo.swift
│ │ ├─ TaskGroupDemoViewModel.swift
│ │ ├─ TaskGroupDemoView.swift
│ │ └─ Tests/
│ ├─ 2.3-DetachedTasks/
│ │ ├─ DetachedTasksDemo.swift
│ │ ├─ DetachedTasksDemoViewModel.swift
│ │ ├─ DetachedTasksDemoView.swift
│ │ └─ Tests/
│ ├─ 2.4-Cancellation/
│ ├─ CancellationDemo.swift
│ ├─ CancellationDemoViewModel.swift
│ ├─ CancellationDemoView.swift
│ └─ Tests/
│
├─ 03-Advanced/
│ ├─ 3.1-Actors/
│ │ ├─ ActorsDemo.swift
│ │ ├─ ActorsDemoViewModel.swift
│ │ ├─ ActorsDemoView.swift
│ │ └─ Tests/
│ ├─ 3.2-AsyncSequences/
│ │ ├─ AsyncSequencesDemo.swift
│ │ ├─ AsyncSequencesDemoViewModel.swift
│ │ ├─ AsyncSequencesDemoView.swift
│ │ └─ Tests/
│ ├─ 3.3-MixingWithCombine/
│ │ ├─ MixingWithCombineDemo.swift
│ │ ├─ MixingWithCombineDemoViewModel.swift
│ │ ├─ MixingWithCombineDemoView.swift
│ │ └─ Tests/
│ ├─ 3.4-PerformanceAndPitfalls/
│ ├─ PerformanceDemo.swift
│ ├─ PerformanceDemoViewModel.swift
│ ├─ PerformanceDemoView.swift
│ └─ Tests/
│
└─ Shared/
├─ MockData.swift
└─ Utilities.swift
```

---

## 📚 Learning Path

### **Beginner**
1. **What is Swift Concurrency?**  
   - The problem it solves  
   - Differences from GCD & completion handlers  

2. **`async` and `await`**  
   - Suspending functions  
   - Sequential async calls  
   - Demo: Simple network call (no cancellation yet)  

3. **`async let`**  
   - Structured parallelism in a single scope  
   - Demo: Compare sequential vs parallel timing  

---

### **Intermediate**
4. **`Task`**  
   - Running async work in a new context  
   - Main actor vs background threads  
   - Demo: Main vs detached task execution  

5. **`TaskGroup`**  
   - Running multiple async tasks in parallel  
   - Collecting and combining results  
   - Demo: Parallel image fetch  

6. **Detached Tasks**  
   - When to use (and when not to)  
   - Demo: Detached background logger example  

7. **Cancellation**  
   - Cooperative cancellation  
   - Checking for `Task.isCancelled` and `Task.checkCancellation()`  
   - Demo: Evolved network call with user and lifecycle cancellation  

---

### **Advanced**
8. **Actors**  
   - Protecting mutable state with isolation  
   - Using `nonisolated` functions  
   - Demo: Counter actor vs race condition  

9. **Async Sequences**  
   - `AsyncSequence` & `AsyncStream`  
   - Consuming with `for await`  
   - Demo: Timer ticks, streaming API simulation  

10. **Mixing with Combine**  
    - Bridging async code with publishers  
    - Demo: Async sequence → Combine publisher chart  

11. **Performance & Pitfalls**  
    - Avoiding priority inversions  
    - Understanding structured concurrency costs  
    - Demo: Compare naive parallel load vs tuned with priority management  


---

## 🛠 How to Run

1. Clone the repo  
2. Open `SwiftConcurrencyTutorial.xcodeproj` in Xcode 15+  
3. Navigate to any example file in the `01-Basics`, `02-Intermediate`, or `03-Advanced` folder  
4. Open the SwiftUI Preview to see the concept in action  

---

## 🧪 Tests

Some examples include basic `XCTest` cases to demonstrate testing async code.  
Run them with: `⌘ + U`

Or from terminal:

`swift test`

---

## 📝 License
MIT

---

## 💡 Author
Built with ❤️ by [Haider Ashfaq](https://haiderashfaq.com/) \
\
Follow my [Medium](https://medium.com/@haiderashfaq) for cool iOS deep-dives and much more!
