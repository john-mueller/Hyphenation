// Hyphenation
// © 2020 John Mueller
// MIT license, see LICENSE.md for details

/// A type representing the separation priority at each offset in a given word fragment.
///
/// The text form of a pattern is a series of letters and numbers, possibly prefixed or suffixed by a period.
///
/// Each odd number represents the priority that a word containing this pattern should be split at that location.
///  Each even number represents the priority that the word should *not* be split at that location.
///  When two patterns in a word overlap, the higher priority at each offset is used.
///
/// A period at the start or end of the pattern indicates that it is only matched at the start or end of a word,
///  respectively.
///
/// - Important: Offsets are measured from the first letter, not the front of the string
///  (i.e. a leading period does not affect the offsets).
///
/// The pattern ".eq5ui5t" would have an `identifier` equal to ".equit", and a `dictionary` equal to [2: 5, 4: 5].
internal struct Pattern {
    // MARK: Properties

    /// The pattern's textual form, omitting the priority numbers.
    let identifier: Identifier
    /// A mapping from each offset to the priority of separation at that offset.
    let priorities: [Offset: Priority]

    // MARK: Initializers

    /// Creates a `Pattern` instance if input string is valid; throws an error otherwise.
    ///
    /// A valid pattern string includes at least one alphabetic character, at least one digit,
    ///  and an optional period at the beginning or the end (but not both).
    ///  No two consecutive characters may be digits, and the string may not contain any other type of character.
    ///
    /// - Parameters:
    ///   - pattern: The textual representation of a pattern.
    ///
    /// - Throws: An error of type `PatternParsingError`.
    init(from pattern: String) throws {
        if pattern.filter({ $0.isLetter }).isEmpty || pattern.filter({ $0.isDigit }).isEmpty {
            throw PatternParsingError.deficientPattern(pattern)
        }

        guard pattern.filter({ !$0.isValid }).isEmpty else {
            throw PatternParsingError.invalidCharacter(pattern)
        }

        let identifier = pattern
            .lowercased()
            .filter { !$0.isDigit }

        var trimmedString = pattern
            .trimmingCharacters(in: .punctuationCharacters)

        var priorities = [Offset: Priority]()

        while let index = trimmedString.firstIndex(where: { $0.isNumber }) {
            let nextIndex = trimmedString.index(after: index)
            if nextIndex < trimmedString.endIndex, trimmedString[nextIndex].isDigit {
                throw PatternParsingError.consecutiveDigits(pattern)
            }

            let offset = trimmedString.distance(from: trimmedString.startIndex, to: index)
            if let priority = Int(String(trimmedString[index])) {
                priorities[offset] = priority
            }
            trimmedString.remove(at: index)
        }

        self.identifier = identifier
        self.priorities = priorities
    }
}

// MARK: Validation extensions

extension Pattern {
    /// A set containing the valid digits for a pattern string.
    fileprivate static let digitSet = Set("123456789")
}

extension Character {
    /// A Boolean value indicating whether this character is in `Pattern.digitSet`.
    fileprivate var isDigit: Bool {
        Pattern.digitSet.contains(self)
    }

    /// A Boolean value indicating whether this character is valid in a pattern string.
    ///
    /// - See Also: `Pattern.init(from:)`
    fileprivate var isValid: Bool {
        isLetter || isDigit || self == "."
    }
}

// MARK: Typealiases

extension Pattern {
    /// A string that represents a pattern's textual form, omitting the priority numbers.
    typealias Identifier = String
    /// An index that represents a potential split location within a pattern string.
    typealias Location = String.Index
    /// An integer that represents the number of indices from the beginning of the pattern string
    ///  to the index of a potential split location.
    typealias Offset = String.IndexDistance
    /// An integer that represents the priority with which a string should be split or not split
    ///  at a given index.
    typealias Priority = Int
}
