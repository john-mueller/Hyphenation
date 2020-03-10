// Hyphenation
// © 2020 John Mueller
// MIT license, see LICENSE.md for details

import Foundation

/// An object representing the contents of a set of `Pattern`s.
///
/// Rather than storing each pattern as a separate `Pattern` instance, a `PatternDictionary`
///  stores the identifier of the pattern, and its collection of hyphenation priorities
///  and their associated offsets in a format which allows quick retrieval and combination.
internal final class PatternDictionary: Copyable {
    // MARK: Properties

    /// The backing storage of the pattern contents.
    private var dictionary: [Pattern.Identifier: [Pattern.Offset: Pattern.Priority]]
    /// The length of the longest identifier in the dictionary.
    private(set) var maxIdentifierLength: Int

    // MARK: Initializers

    /// Creates a `PatternDictionary` instance using the default English patterns.
    init() {
        dictionary = PatternDictionary.defaultDictionary.dictionary
        maxIdentifierLength = PatternDictionary.defaultMaxLength
    }

    /// Creates a `PatternDictionary` instance using the patterns contained in a string.
    ///
    /// The patterns can be separated by newlines and/or whitespace.
    ///  See `Pattern.init(from:)` documentation for proper pattern syntax.
    ///
    /// - Parameters:
    ///   - string: A string containing patterns.
    ///
    /// - Throws: An error of type `PatternParsingError`.
    init(string: String) throws {
        dictionary = [:]
        maxIdentifierLength = 0

        try string.components(separatedBy: .newlines).forEach { line in
            guard !line.hasPrefix("//") else { return }
            try line.components(separatedBy: .whitespaces).forEach { substring in
                guard !substring.isEmpty else { return }
                let pattern = try Pattern(from: String(substring))
                dictionary[pattern.identifier] = pattern.priorities
                maxIdentifierLength = max(maxIdentifierLength, pattern.identifier.count)
            }
        }
    }

    /// Creates a `PatternDictionary` instance using the patterns contained in a file.
    ///
    /// The patterns can be separated by newlines and/or whitespace.
    ///  See `Pattern.init(from:)` documentation for proper pattern syntax.
    ///
    /// - Parameters:
    ///   - fileURL: A URL referring to a file containing patterns.
    ///
    /// - Throws: An error of type `PatternParsingError`, or any error thrown by `String(contentsOf:encoding:)`.
    convenience init(fileURL: URL) throws {
        try self.init(string: try String(contentsOf: fileURL, encoding: .utf8))
    }

    /// Creates a `PatternDictionary` instance with a copy of the data in an existing instance.
    ///
    /// - Parameters:
    ///   - copy: The `PatternDictionary` which will be copied.
    init(copy: PatternDictionary) {
        dictionary = copy.dictionary
        maxIdentifierLength = copy.maxIdentifierLength
    }

    // MARK: Subscripts

    /// Returns the dictionary mapping hyphenation offsets to priorities for a given pattern identifier,
    ///  if it exists. Returns `nil` otherwise.
    subscript(identifier: Pattern.Identifier) -> [Pattern.Offset: Pattern.Priority]? {
        dictionary[identifier]
    }
}

// MARK: Default patterns

extension PatternDictionary {
    /// A URL refering to a file containing the default English patterns.
    private static let defaultFileURL = URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent("Patterns/hyph-en-us.pat.txt")

    /// A `PatternDictionary` containing the default English patterns.
    private static var defaultDictionary = try! PatternDictionary(fileURL: defaultFileURL)
    // swiftlint:disable:previous force_try

    /// The length of the longest identifier in the default dictionary.
    private static var defaultMaxLength = defaultDictionary.dictionary.keys.reduce(0) { max($0, $1.count) }
}
