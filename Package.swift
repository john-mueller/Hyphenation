// swift-tools-version:5.4

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
        .testTarget(
          name: "HyphenationTests",
          dependencies: ["Hyphenation"],
          resources: [.process("TextFiles")]
        )
    ]
)
