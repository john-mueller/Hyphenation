// Hyphenation
// © 2020 John Mueller
// MIT license, see LICENSE.md for details

import Foundation

/// An object that hyphenates text using the Knuth-Liang algorithm.
///
/// The Knuth-Liang hyphenation algorithm identifies likely points at which a word can be hyphenated,
///  or split across two lines of text. By default, the `hyphenate(text:)` method inserts U+00AD (soft hyphen)
///  at the calculated break points. This character is invisible unless the word occurs at the end of a line,
///  and breaking would improve text flow. Then it is rendered as a normal hyphen.
///
/// The example below shows how to hyphenate a string, specifying the hyphen character as the separator:
///
/// **Example**
/// ```
/// let hyphenator = Hyphenator()
/// hyphenator.separator = "-"
///
/// let text = "This algorithm identifies likely hyphenation points."
/// print(hyphenator.hyphenate(text: text)
/// // This al-go-rithm iden-ti-fies like-ly hy-phen-ation points.
/// ```
///
/// The algorithm is designed to prioritize the prevention of incorrect hyphenations over finding every correct
///  hyphenation—missing a single hyphenation rarely effects text flow meaningfully, but bad hyphenation can be
///  rather noticable. Nevertheless, the algorithm may occasionally produce unexpected results for brand names
///  or other unusual words. In this case, you may manually specify a desired hyphenation using exceptions.
///
/// **Example**
/// ```
/// let hyphenator = Hyphenator()
/// hyphenator.separator = "-"
///
/// print(hyphenator.hyphenate(text: "Microsoft sesquipedalian"))
/// // Mi-crosoft sesquipedalian
///
/// hyphenator.addCustomExceptions(["Micro-soft", "ses-qui-pe-da-li-an"])
///
/// print(hyphenator.hyphenate(text: "Microsoft sesquipedalian"))
/// // Micro-soft ses-qui-pe-da-li-an
/// ```
///
/// The library includes American English patterns by default. Patterns for many other languages are available
///  online with varying licenses; see Hyphenation package README for more details.
///
/// - Note: The `Hyphenator` class is thread-safe, and can be used to hyphenate on multiple threads simultaneously
///    (although the performance benefits over using two instances are negligible).
///
/// - Important: You should not apply the `hyphenate(text:)` method directly to strings containing HTML or code,
///    as the code elements may be erroneously hyphenated. A safer approach is to use another tool capable of
///    identifying HTML or code elements and applying hyphenation only to plain text content.
///    See [HyphenationPublishPlugin](https://github.com/john-mueller/HyphenationPublishPlugin) for an example
///    hyphenating HTML using [SwiftSoup](https://github.com/scinfu/SwiftSoup).
public final class Hyphenator {
    // MARK: Properties

    /// The minimum character count for a word to be hyphenated.
    public var minLength = 5 { didSet { clearCache() } }
    /// The minimum number of characters between the beginning of the word and a hyphenation point.
    public var minLeading = 2 { didSet { clearCache() } }
    /// The minimum number of characters between the end of the word and a hyphenation point.
    public var minTrailing = 3 { didSet { clearCache() } }
    /// The character to insert at each hyphenation point.
    public var separator: Character = "\u{00AD}" { didSet { clearCache() } }

    /// A cache providing quick access to words which have already been hyphenated.
    private let cache = HyphenatorCache()

    /// A dictionary providing quick access to pattern information.
    private let patternDictionary: PatternDictionary
    /// A dictionary providing quick access to exception information.
    private let exceptionDictionary: ExceptionDictionary

    // MARK: Initializers

    /// Creates a `Hyphenator` instance using the default English patterns and exceptions.
    public init() {
        patternDictionary = PatternDictionary()
        exceptionDictionary = ExceptionDictionary()
    }

    /// Creates a `Hyphenator` instance using the patterns and exceptions contained in strings.
    ///
    /// The patterns and exceptions can be separated by newlines and/or whitespace.
    ///
    /// See `PatternParsingError` documentation for correct pattern syntax.
    ///
    /// - Parameters:
    ///   - patterns: A string containing patterns.
    ///   - exceptions: A string containing exceptions.
    ///
    /// - Throws: An error of type `PatternParsingError`.
    public init(patterns: String, exceptions: String? = nil) throws {
        patternDictionary = try PatternDictionary(string: patterns)
        exceptionDictionary = ExceptionDictionary(string: exceptions ?? "")
    }

    /// Creates a `Hyphenator` instance using the patterns and exceptions contained in files.
    ///
    /// The patterns and exceptions can be separated by newlines and/or whitespace.
    ///
    /// See `PatternParsingError` documentation for correct pattern syntax.
    ///
    /// - Parameters:
    ///   - patternFile: A URL referreing to a file containing patterns.
    ///   - exceptionFile: A URL referreing to a file containing exceptions.
    ///
    /// - Throws: An error of type `PatternParsingError`, or any error thrown by `String(contentsOf:encoding:)`.
    public init(patternFile: URL, exceptionFile: URL? = nil) throws {
        patternDictionary = try PatternDictionary(fileURL: patternFile)
        if let exceptionFile = exceptionFile {
            exceptionDictionary = try ExceptionDictionary(fileURL: exceptionFile)
        } else {
            exceptionDictionary = ExceptionDictionary(string: "")
        }
    }

    /// Creates a `Hyphenator` instance with a copy of the data in an existing instance.
    ///
    /// The cache is not copied, and a deep copy of the `patternDictionary` and `exceptionDictionary` is performed.
    ///
    /// - Parameters:
    ///   - copy: The `Hyphenator` which will be copied.
    init(copy: Hyphenator) {
        minLength = copy.minLength
        minLeading = copy.minLeading
        minTrailing = copy.minTrailing
        separator = copy.separator

        patternDictionary = copy.patternDictionary.copy()
        exceptionDictionary = copy.exceptionDictionary.copy()
    }
}

// MARK: Copying

extension Hyphenator: Copyable {
    /// Returns a new `Hyphenator` instance, copied from an existing instance.
    public func copy() -> Self {
        Self(copy: self)
    }
}

// MARK: Methods

extension Hyphenator {
    /// Returns a new `String` formed by finding hyphenation points in the input text and
    ///  inserting the `separator` character at those points.
    ///
    /// - Complexity: Hyphenation is an O(n) operation.
    ///
    /// - Parameters:
    ///   - text: A `String` or `Substring` containing text to be hyphenated.
    public func hyphenate<T: StringProtocol>(text: T) -> String {
        TokenSequence(from: text, separator: separator)
            .lazy
            .map(render)
            .joined()
    }

    /// Returns a new `String` formed by removing the `separator` character from the input text.
    ///
    /// - Important: Hyphenating a string is not guarenteed to be a reversible operation—if
    ///    the original string contained `separator` characters, they will also be
    ///    removed by this function.
    public func unhyphenate<T: StringProtocol>(text: T) -> String {
        text.replacingOccurrences(of: "\(separator)", with: "")
    }

    /// Clears the `Hyphenator`'s internal cache.
    ///
    /// It is typically unnecessary to clear the cache, unless one wants to keep a configured `Hyphenator`
    ///  instance and ensure it does not take any more memory than necessary.
    public func clearCache() {
        cache.clearCache()
    }
}

// MARK: Exceptions

extension Hyphenator {
    /// Adds custom exceptions to the `Hyphenator`.
    ///
    /// - Parameters:
    ///   - exceptions: A collection of words to be treated as exceptions, with hyphens ("-") inserted
    ///      at the desired hyphenation points.
    public func addCustomExceptions<T: Collection>(_ exceptions: T) where T.Element == String {
        exceptionDictionary.addCustomExceptions(exceptions)
    }

    /// Removes custom exceptions from the `Hyphenator`.
    ///
    /// - Parameters:
    ///   - exceptions: A collection of words that should not have custom hyphenation exceptions.
    public func removeCustomExceptions<T: Collection>(_ exceptions: T) where T.Element == String {
        exceptionDictionary.removeCustomExceptions(exceptions)
    }

    /// Removes all custom exceptions that have been added to the `Hyphenator` using `addCustomExceptions(_:)`.
    public func removeAllCustomExceptions() {
        exceptionDictionary.removeAllCustomExceptions()
    }
}

// MARK: Private methods

extension Hyphenator {
    /// Converts a `Token` to a string, hyphenated if necessary.
    ///
    /// - Parameters:
    ///   - token: The `Token` to convert.
    private func render(token: Token) -> String {
        switch token {
        case let .nonHyphenatable(tokenString):
            return tokenString
        case let .hyphenatable(tokenString):
            if tokenString.count < minLength {
                return tokenString
            }

            if let hyphenatedWord = exceptionDictionary[tokenString] {
                return hyphenatedWord.replacingOccurrences(of: "-", with: "\(separator)")
            }

            if let hyphenatedWord = cache[tokenString] {
                return hyphenatedWord
            } else {
                let hyphenatedWord = hyphenate(word: tokenString)
                cache[tokenString] = hyphenatedWord
                return hyphenatedWord
            }
        }
    }

    /// Hyphenates a single word by finding the patterns it contains, merging their hyphenation priorities,
    ///  and inserting the `separator` character at the proper locations.
    ///
    /// - Parameters:
    ///   - word: The word to be hyphenated.
    private func hyphenate(word: String) -> String {
        let lowercasedWord = word.lowercased()

        let matchedPatterns = patterns(in: lowercasedWord)

        let mergedPriorities = priorities(byMerging: matchedPatterns, in: lowercasedWord)

        return separating(word, using: mergedPriorities)
    }

    /// Returns an array containing pairs of locations and pattern identifiers contained within the word.
    ///
    /// - Parameters:
    ///   - word: The word in which to find subpatterns.
    private func patterns(in word: String) -> [(Location, Identifier)] {
        var patterns = [(Location, Identifier)]()

        var startIndex = word.startIndex
        var endIndex = word.index(startIndex, offsetBy: 1, limitedBy: word.endIndex)
        while endIndex != nil {
            let identifier = String(word[startIndex ..< endIndex!])
            if patternDictionary[identifier] != nil {
                patterns.append((startIndex, identifier))
            }

            if startIndex == word.startIndex, patternDictionary["." + identifier] != nil {
                patterns.append((startIndex, "." + identifier))
            }

            let distance = word.distance(from: startIndex, to: endIndex!)
            if endIndex == word.endIndex || distance >= patternDictionary.maxIdentifierLength {
                if patternDictionary[identifier + "."] != nil {
                    patterns.append((startIndex, identifier + "."))
                }

                startIndex = word.index(after: startIndex)
                endIndex = word.index(startIndex, offsetBy: 1, limitedBy: word.endIndex)
            } else {
                endIndex = word.index(after: endIndex!)
            }
        }

        return patterns
    }

    /// Returns a mapping from pattern locations to hyphenation priorities.
    ///
    /// - Parameters:
    ///   - patterns: An array of pairs of locations and pattern identifiers.
    ///   - word: The word in which the patterns are contained.
    private func priorities(byMerging patterns: [(Location, Identifier)], in word: String) -> [Location: Priority] {
        var mergedPriorities = [Location: Priority]()

        patterns.forEach { location, identifier in
            if let prioritiesByOffset = patternDictionary[identifier] {
                var prioritiesByLocation = [Location: Priority]()
                for offset in prioritiesByOffset.keys {
                    let index = word.index(location, offsetBy: offset)
                    prioritiesByLocation[index] = prioritiesByOffset[offset]
                }
                mergedPriorities.merge(prioritiesByLocation, uniquingKeysWith: max)
            }
        }

        return mergedPriorities
    }

    /// Returns the result of inserting the `separator` character into the word at the proper locations.
    ///
    /// - Parameters:
    ///   - word: The word to be hyphenated.
    ///   - priorities: The mapping from pattern locations to hyphenation priorities.
    private func separating(_ word: String, using priorities: [Location: Priority]) -> String {
        var hyphenatedWord = word
        let minIndex = word.index(word.startIndex, offsetBy: minLeading)
        let maxIndex = word.index(word.endIndex, offsetBy: -minTrailing)

        for location in priorities.filter({ location, priority in
            if priority.isMultiple(of: 2) { return false }
            if location < minIndex { return false }
            if location > maxIndex { return false }
            return true
        }).keys.sorted().reversed() {
            hyphenatedWord.insert(separator, at: location)
        }

        return hyphenatedWord
    }
}

// MARK: Typealiases

extension Hyphenator {
    /// A string that represents a pattern's textual form, omitting the priority numbers.
    private typealias Identifier = Pattern.Identifier
    /// An index that represents a potential split location within a pattern string.
    private typealias Location = Pattern.Location
    /// An integer that represents the number of indices from the beginning of the pattern string
    ///  to the index of a potential split location.
    private typealias Offset = Pattern.Offset
    /// An integer that represents the priority with which a string should be split or not split
    ///  at a given index.
    private typealias Priority = Pattern.Priority
}
