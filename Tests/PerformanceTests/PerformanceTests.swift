// Hyphenation
// © 2020 John Mueller
// MIT license, see LICENSE.md for details

// swiftlint:disable explicit_top_level_acl

import Hyphenation
import XCTest

/// These tests should be run with Release configuration
///  (e.g. `swift test -c release`)
final class PerformanceTests: XCTestCase {
    let testString: String = TestStrings.prideAndPrejudice

    func testSpeed1Constitution() {
        let hyphenator = Hyphenator()
        let string = TestStrings.constitution
        _ = hyphenator.hyphenate(text: string)
        measure {
            _ = hyphenator.hyphenate(text: string)
        }
    }

    func testSpeed2PrideAndPrejudice() {
        let hyphenator = Hyphenator()
        let string = TestStrings.prideAndPrejudice
        _ = hyphenator.hyphenate(text: string)
        measure {
            _ = hyphenator.hyphenate(text: string)
        }
    }

    func testSpeed3GreatExpectations() {
        let hyphenator = Hyphenator()
        let string = TestStrings.greatExpectations
        _ = hyphenator.hyphenate(text: string)
        measure {
            _ = hyphenator.hyphenate(text: string)
        }
    }

    func testSpeed4WarAndPeace() {
        let hyphenator = Hyphenator()
        let string = TestStrings.warAndPeace
        _ = hyphenator.hyphenate(text: string)
        measure {
            _ = hyphenator.hyphenate(text: string)
        }
    }

    func testSpeed5KingJamesBible() {
        let hyphenator = Hyphenator()
        let string = TestStrings.kingJamesBible
        _ = hyphenator.hyphenate(text: string)
        measure {
            _ = hyphenator.hyphenate(text: string)
        }
    }

    func testSpeed6Clarissa() {
        let hyphenator = Hyphenator()
        let string = TestStrings.clarissa
        _ = hyphenator.hyphenate(text: string)
        measure {
            _ = hyphenator.hyphenate(text: string)
        }
    }

    func testSequentialPerformance() {
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

    func testConcurrentPerformance() {
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

    func testIndependentPerformance() {
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

    func testLongWordPerformance() {
        let hyphenator = Hyphenator()
        let word = "pneumonoultramicroscopicsilicovolcanoconiosis"
        let text = String(repeating: word, count: 10)
        measure {
            hyphenator.clearCache()
            _ = hyphenator.hyphenate(text: text)
        }
    }
}
