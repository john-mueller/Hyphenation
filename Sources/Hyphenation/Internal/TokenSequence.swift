// Hyphenation
// © 2020 John Mueller
// MIT license, see LICENSE.md for details

/// A type representing a sequence of Tokens, each of which is either a hyphenatable or non-hyphenatable string.
///
/// Any substring consisting solely of letters will be returnes as a hyphenatable token.
///  Any other substring is returned as a non-hyphenatable token.
///
/// **Example**
/// ```
/// var tokens = TokenSequence(from: "letters 123 mixed123word")
/// while let token = tokens.next() {
///     print(token)
/// }
/// // hyphenatable("letters")
/// // nonHyphenatable(" 123 ")
/// // hyphenatable("mixed")
/// // nonHyphenatable("123")
/// // hyphenatable("word")
/// ```
///
/// The one exception is that pre-hyphenated words are also returned as non-hyphenatable tokens.
///  When a single hyphen or separator character separates two normally hyphenatable tokens,
///  they are returned, along with the separator, as a non-hyphenatable token.
///
/// **Example**
/// ```
/// var tokens = TokenSequence(from: "super-fluous")
/// while let token = tokens.next() {
///     print(token)
/// }
/// // nonHyphenatable("super-fluous")
/// var tokens = TokenSequence(from: "super fluous")
/// while let token = tokens.next() {
///     print(token)
/// }
/// // hyphenatable("super")
/// // nonHyphenatable(" ")
/// // hyphenatable("fluous")
/// ```
///
/// - Attention: The sequence can only be iterated over once—create a new instance if additional traversal is required.
///
/// - Complexity: Traversing the sequence is an O(n) operation.
internal struct TokenSequence<T: StringProtocol>: Sequence, IteratorProtocol {
    // MARK: Properties

    /// The base `String` or `Substring` to be split into `Token`s.
    private let text: T
    /// The current index that has been reached in `text`.
    private var index: String.Index
    /// A separator character which counts as pre-hyphenation.
    private let separator: Character

    // MARK: Initializers

    /// Creates a `TokenSequence` instance.
    ///
    /// - Parameters:
    ///   - text: The base `String` or `Substring` to be split into `Token`s.
    ///   - separator: A separator character which counts as pre-hyphenation.
    init(from text: T, separator: Character = "-") {
        self.text = text
        self.index = text.startIndex
        self.separator = separator
    }
}

// MARK: Methods

extension TokenSequence {
    /// Returns the next `Token`, if available, or `nil` otherwise.
    mutating func next() -> Token? {
        guard index != text.endIndex else {
            return nil
        }

        let startIndex = index
        let currentTypeIsLetter = text[index].isLetter
        var containsSeparator = false

        let isSameType: (Character) -> Bool = { character in
            character.isLetter == currentTypeIsLetter
        }

        loop: while index != text.endIndex {
            switch text[index] {
            case "-", separator:
                defer { advanceIndex() }
                if currentTypeIsLetter, nextCharacterIsLetter {
                    containsSeparator = true
                } else {
                    break loop
                }
            case isSameType:
                advanceIndex()
            default:
                break loop
            }
        }

        if currentTypeIsLetter, !containsSeparator {
            return .hyphenatable(String(text[startIndex ..< index]))
        }

        return .nonHyphenatable(String(text[startIndex ..< index]))
    }
}

// MARK: Private methods

extension TokenSequence {
    /// Advances the current index by one character.
    private mutating func advanceIndex() {
        index = text.index(after: index)
    }

    /// Safely checks if the next character is a letter.
    private var nextCharacterIsLetter: Bool {
        let nextIndex = text.index(after: index)
        guard nextIndex < text.endIndex else { return false }
        return text[nextIndex].isLetter
    }
}

// MARK: Pattern matching

/// Matches a character using a closure which transforms the character into a boolean.
private func ~= (lhs: (Character) -> Bool, rhs: Character) -> Bool {
    lhs(rhs)
}
