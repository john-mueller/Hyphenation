// Hyphenation
// © 2020 John Mueller
// MIT license, see LICENSE.md for details

/// An error that can be thrown when constructing a `Pattern` instance.
///
/// A valid pattern string includes at least one alphabetic character, at least one digit,
///  and an optional period at the beginning or the end (but not both).
///  No two consecutive characters may be digits, and the string may not contain any other type of character.
public enum PatternParsingError: Error, Equatable {
    /// A pattern string which did not contain at least one letter and one digit from between 1 and 9, inclusive.
    case deficientPattern(String)
    /// A pattern string which contained a character that was not alphabetic, a digits 1-9, or a period.
    case invalidCharacter(String)
    /// A pattern string which contained multiple consecutive digits.
    case consecutiveDigits(String)
}
