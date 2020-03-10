// swift-tools-version:5.1

// Hyphenation
// © 2020 John Mueller
// MIT license, see LICENSE.md for details

// swiftlint:disable explicit_top_level_acl

import PackageDescription

let package = Package(
    name: "Hyphenation",
    products: [
        .library(name: "Hyphenation", targets: ["Hyphenation"]),
    ],
    targets: [
        .target(name: "Hyphenation"),
        .testTarget(name: "HyphenationTests", dependencies: ["Hyphenation"]),
        .testTarget(name: "PerformanceTests", dependencies: ["Hyphenation"]),
        .testTarget(name: "ThreadSafetyTests", dependencies: ["Hyphenation"]),
    ]
)

import class Foundation.ProcessInfo

// conditional application of test targets based on environment variable
switch ProcessInfo.processInfo.environment["HYPHENATION_TEST_TYPE"]?.lowercased() {
case "hyphenation":
    package.targets.removeAll(where: { $0.type == .test && $0.name != "HyphenationTests" })
case "performance":
    package.targets.removeAll(where: { $0.type == .test && $0.name != "HyphenationTests" })
    package.targets.first(where: { $0.type == .test })?.path = "Tests/PerformanceTests"
case "thread-safety":
    package.targets.removeAll(where: { $0.type == .test && $0.name != "HyphenationTests" })
    package.targets.first(where: { $0.type == .test })?.path = "Tests/ThreadSafetyTests"
default:
    break
}
