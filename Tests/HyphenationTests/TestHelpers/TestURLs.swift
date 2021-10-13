// Hyphenation
// © 2020 John Mueller
// MIT license, see LICENSE.md for details

// swiftlint:disable force_try

import Foundation

internal extension URL {
    private static func resource(_ name: String) -> URL {
        URL(fileURLWithPath: Bundle.module.path(forResource: name, ofType: nil)!)
    }

    static var testPatterns = resource("TestPatterns.txt")
    static var testExceptions = resource("TestExceptions.txt")

    fileprivate static let constitution = resource("Constitution.txt")
    fileprivate static let prideAndPrejudice = resource("PrideAndPrejudice.txt")
    fileprivate static let greatExpectations = resource("GreatExpectations.txt")
    fileprivate static let warAndPeace = resource("WarAndPeace.txt")
    fileprivate static let kingJamesBible = resource("KingJamesBible.txt")
    fileprivate static let clarissa = resource("Clarissa.txt")
}

internal extension String {
    static let constitution = try! String(contentsOf: .constitution)
    static let prideAndPrejudice = try! String(contentsOf: .prideAndPrejudice)
    static let greatExpectations = try! String(contentsOf: .greatExpectations)
    static let warAndPeace = try! String(contentsOf: .warAndPeace)
    static let kingJamesBible = try! String(contentsOf: .kingJamesBible)
    static let clarissa = try! String(contentsOf: .clarissa)
}
