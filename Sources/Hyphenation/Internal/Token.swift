// Hyphenation
// © 2020 John Mueller
// MIT license, see LICENSE.md for details

/// An enum representing whether or not a string is hyphenatable.
internal enum Token {
    /// A string that should be hyphenated.
    case hyphenatable(String)
    /// A string that should not be hyphenated.
    case nonHyphenatable(String)
}
