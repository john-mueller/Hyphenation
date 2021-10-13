// Hyphenation
// © 2020 John Mueller
// MIT license, see LICENSE.md for details

// swiftlint:disable explicit_top_level_acl

import Hyphenation
import XCTest

/// These tests should be run with Release configuration
///  (e.g. `swift test -c release`)
final class PerformanceTests: XCTestCase {
    let testString: String = .prideAndPrejudice

    func testSpeed1Constitution() throws {
        let hyphenator = Hyphenator()
        let string: String = .constitution
        _ = hyphenator.hyphenate(text: string)
        measure {
            _ = hyphenator.hyphenate(text: string)
        }
    }

    func testSpeed2PrideAndPrejudice() throws {
        let hyphenator = Hyphenator()
        let string: String = .prideAndPrejudice
        _ = hyphenator.hyphenate(text: string)
        measure {
            _ = hyphenator.hyphenate(text: string)
        }
    }

    func testSpeed3GreatExpectations() throws {
        let hyphenator = Hyphenator()
        let string: String = .greatExpectations
        _ = hyphenator.hyphenate(text: string)
        measure {
            _ = hyphenator.hyphenate(text: string)
        }
    }

    func testSpeed4WarAndPeace() throws {
        let hyphenator = Hyphenator()
        let string: String = .warAndPeace
        _ = hyphenator.hyphenate(text: string)
        measure {
            _ = hyphenator.hyphenate(text: string)
        }
    }

    func testSpeed5KingJamesBible() throws {
        let hyphenator = Hyphenator()
        let string: String = .kingJamesBible
        _ = hyphenator.hyphenate(text: string)
        measure {
            _ = hyphenator.hyphenate(text: string)
        }
    }

    func testSpeed6Clarissa() throws {
        let hyphenator = Hyphenator()
        let string: String = .clarissa
        _ = hyphenator.hyphenate(text: string)
        measure {
            _ = hyphenator.hyphenate(text: string)
        }
    }

    func testSequentialPerformance() throws {
        let hyphenator = Hyphenator()
        let group = DispatchGroup()
        measure {
            hyphenator.clearCache()
            group.enter()
            DispatchQueue.global(qos: .userInitiated).async {
                _ = hyphenator.hyphenate(text: self.testString)
                _ = hyphenator.hyphenate(text: self.testString)
                group.leave()
            }
            group.wait()
        }
    }

    func testConcurrentPerformance() throws {
        let hyphenator = Hyphenator()
        let group = DispatchGroup()
        measure {
            hyphenator.clearCache()
            group.enter()
            DispatchQueue.global(qos: .userInitiated).async {
                _ = hyphenator.hyphenate(text: self.testString)
                group.leave()
            }
            group.enter()
            DispatchQueue.global(qos: .userInitiated).async {
                _ = hyphenator.hyphenate(text: self.testString)
                group.leave()
            }
            group.wait()
        }
    }

    func testIndependentPerformance() throws {
        let hyphenator1 = Hyphenator()
        let hyphenator2 = Hyphenator()
        let group = DispatchGroup()
        measure {
            hyphenator1.clearCache()
            hyphenator2.clearCache()
            group.enter()
            DispatchQueue.global(qos: .userInitiated).async {
                _ = hyphenator1.hyphenate(text: self.testString)
                group.leave()
            }
            group.enter()
            DispatchQueue.global(qos: .userInitiated).async {
                _ = hyphenator2.hyphenate(text: self.testString)
                group.leave()
            }
            group.wait()
        }
    }

    func testLongWordPerformance() throws {
        let hyphenator = Hyphenator()
        let word = "pneumonoultramicroscopicsilicovolcanoconiosis"
        let text = String(repeating: word, count: 10)
        measure {
            hyphenator.clearCache()
            _ = hyphenator.hyphenate(text: text)
        }
    }
}
