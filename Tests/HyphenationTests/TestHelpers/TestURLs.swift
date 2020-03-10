// Hyphenation
// © 2020 John Mueller
// MIT license, see LICENSE.md for details

import Foundation

internal let testPatternsURL = URL(fileURLWithPath: #file)
    .deletingLastPathComponent()
    .appendingPathComponent("TestPatterns.txt")

internal let testExceptionsURL = URL(fileURLWithPath: #file)
    .deletingLastPathComponent()
    .appendingPathComponent("TestExceptions.txt")

internal let badPatternsURL = URL(fileURLWithPath: #file)
    .deletingLastPathComponent()
    .appendingPathComponent("BadPatterns.txt")
