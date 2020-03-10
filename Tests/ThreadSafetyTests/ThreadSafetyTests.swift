// Hyphenation
// © 2020 John Mueller
// MIT license, see LICENSE.md for details

// swiftlint:disable explicit_top_level_acl

import Hyphenation
import XCTest

/// These tests should be run with Debug configuration and thread santizer
///  (e.g. `swift test -c debug --sanitize=thread`)
final class ThreadSafetyTests: XCTestCase {
    func testHyphenatorCacheThreadSafety() {
        let hyphenator = Hyphenator()
        let queue = DispatchQueue(
            label: "hyphenation-cache",
            qos: .userInitiated,
            attributes: [.concurrent],
            target: .global()
        )
        let group = DispatchGroup()
        for _ in 0 ... 100 {
            group.enter()
            queue.async {
                _ = hyphenator.hyphenate(text: "modularity")
                hyphenator.clearCache()
                group.leave()
            }
        }
        group.wait()
    }

    func testCustomExceptionsThreadSafety() {
        let hyphenator = Hyphenator()
        let queue = DispatchQueue(
            label: "hyphenation-exceptions",
            qos: .userInitiated,
            attributes: [.concurrent],
            target: .global()
        )
        let group = DispatchGroup()
        for _ in 0 ... 100 {
            group.enter()
            queue.async {
                hyphenator.addCustomExceptions(["modul-arity", "pro-ject"])
                hyphenator.removeCustomExceptions(["project"])
                _ = hyphenator.hyphenate(text: "modularity")
                hyphenator.removeAllCustomExceptions()
                _ = hyphenator.copy()
                group.leave()
            }
        }
        group.wait()
    }
}
