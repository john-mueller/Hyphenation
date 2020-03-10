// Hyphenation
// © 2020 John Mueller
// MIT license, see LICENSE.md for details

import Foundation

/// A type representing how a particular string should be hyphenated.
///
/// An exception overrides the hyphenation a word would normally receive based on patterns.
internal struct Exception {
    // MARK: Properties

    /// The exception's textual form, omitting the hyphens.
    let identifier: Identifier
    /// An array of locations at which the string should be split.
    let locations: [Location]

    // MARK: Initializers

    /// Creates an `Exception` instance from a `String`.
    ///
    /// - Parameters:
    ///   - hyphenation: The word to be treated as an exception, with hyphens ("-") inserted
    ///      at the desired hyphenation points.
    init(from hyphenation: String) {
        let identifier = hyphenation
            .lowercased()
            .replacingOccurrences(of: "-", with: "")

        var trimmedString = hyphenation

        var locations = [Location]()

        while let index = trimmedString.firstIndex(of: "-") {
            locations.append(index)
            trimmedString.remove(at: index)
        }

        self.identifier = identifier
        self.locations = locations
    }
}

// MARK: Typealiases

extension Exception {
    /// A string that represents an exception's textual form, omitting the hyphens.
    typealias Identifier = String
    /// An index that represents a split location within an exception string.
    typealias Location = String.Index
}
