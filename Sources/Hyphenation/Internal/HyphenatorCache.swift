// Hyphenation
// © 2020 John Mueller
// MIT license, see LICENSE.md for details

import Foundation

/// An object that provides thread-safe caching for hyphenated words.
///
/// The backing dictionary is accessed solely through thread-safe subscript, to prevent data races.
///
/// **Example**
/// ```
/// let cache = HyphenatorCache()
/// cache["hyphen"] = "hy-phen"
/// print(cache["hyphen"])
/// // hy-phen
/// ```
internal final class HyphenatorCache {
    // MARK: Properties

    /// A dictionary mapping strings to their hyphenated forms.
    private var cache = [String: String]()
    /// A lock to prevent simultaneously reading from and writing to cache.
    private let cacheLock = NSLock()

    // MARK: Subscripts

    /// Permits thread-safe access to `cache` dictionary.
    subscript(word: String) -> String? {
        get {
            cacheLock.lock()
            defer { cacheLock.unlock() }
            return cache[word]
        }
        set(newValue) {
            cacheLock.lock()
            cache[word] = newValue
            cacheLock.unlock()
        }
    }
}

// MARK: Methods

extension HyphenatorCache {
    /// Empties the cache.
    func clearCache() {
        cacheLock.lock()
        cache = [:]
        cacheLock.unlock()
    }
}
