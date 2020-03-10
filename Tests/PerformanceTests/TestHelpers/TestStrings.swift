// Hyphenation
// © 2020 John Mueller
// MIT license, see LICENSE.md for details

// swiftlint:disable force_try

import Foundation

internal enum TestStrings {
    private static let folderURL = URL(fileURLWithPath: #file)
        .deletingLastPathComponent()

    static let constitution = try! String(contentsOf: folderURL.appendingPathComponent("Constitution.txt"))
    static let prideAndPrejudice = try! String(contentsOf: folderURL.appendingPathComponent("PrideAndPrejudice.txt"))
    static let greatExpectations = try! String(contentsOf: folderURL.appendingPathComponent("GreatExpectations.txt"))
    static let warAndPeace = try! String(contentsOf: folderURL.appendingPathComponent("WarAndPeace.txt"))
    static let kingJamesBible = try! String(contentsOf: folderURL.appendingPathComponent("KingJamesBible.txt"))
    static let clarissa = try! String(contentsOf: folderURL.appendingPathComponent("Clarissa.txt"))
}
