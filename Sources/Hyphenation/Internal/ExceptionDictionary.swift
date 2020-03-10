// Hyphenation
// © 2020 John Mueller
// MIT license, see LICENSE.md for details

import Foundation

/// An object representing the contents of a set of `Exception`s.
///
/// Internally, the exceptions are stored in two separate categories—default exceptions provided
///  at intantiation, and those added subsequently through the `addCustomException(_:)` method.
///  Custom exceptions take precedence over default exceptions.
internal final class ExceptionDictionary: Copyable {
    // MARK: Properties

    /// The backing storage of default exception contents.
    private var defaultExceptions: [Exception.Identifier: [Exception.Location]]
    /// The backing storage of user-created exception contents.
    private var customExceptions: [Exception.Identifier: [Exception.Location]]
    /// A lock to prevent simultaneously reading from and writing to custom exceptions dictionary.
    private let customExceptionsLock = NSLock()

    // MARK: Initializers

    /// Creates an `ExceptionDictionary` instance using the default English exceptions.
    init() {
        defaultExceptions = ExceptionDictionary.defaultDictionary.defaultExceptions
        customExceptions = [:]
    }

    /// Creates an `ExceptionDictionary` instance using the exceptions contained in a string.
    ///
    /// The exceptions can be separated by newlines and/or whitespace.
    ///  See `Exception.init(from:)` documentation for proper exception syntax.
    ///
    /// - Parameters:
    ///   - string: A string containing exceptions.
    init(string: String) {
        defaultExceptions = [:]
        customExceptions = [:]

        string.components(separatedBy: .newlines).forEach { line in
            guard !line.hasPrefix("//") else { return }
            line.components(separatedBy: .whitespaces)
                .forEach { substring in
                    let exception = Exception(from: String(substring))
                    defaultExceptions[exception.identifier] = exception.locations
            }
        }
    }

    /// Creates an `ExceptionDictionary` instance using the exceptions contained in a file.
    ///
    /// The exceptions can be separated by newlines and/or whitespace.
    ///  See `Exception.init(from:)` documentation for proper exception syntax.
    ///
    /// - Parameters:
    ///   - string: A URL referring to a file containing exceptions.
    ///
    /// - Throws: Any error thrown by `String(contentsOf:encoding:)`.
    convenience init(fileURL: URL) throws {
        self.init(string: try String(contentsOf: fileURL, encoding: .utf8))
    }

    /// Creates an `ExceptionDictionary` instance with a copy of the data in an existing instance.
    ///
    /// - Parameters:
    ///   - copy: The `ExceptionDictionary` on which to perform a deep copy.
    init(copy: ExceptionDictionary) {
        defaultExceptions = copy.defaultExceptions
        copy.customExceptionsLock.lock()
        customExceptions = copy.customExceptions
        copy.customExceptionsLock.unlock()
    }

    // MARK: Subscripts

    /// Returns the exception hyphenation for a given word, if it exists. Returns `nil` otherwise.
    subscript(word: String) -> String? {
        let lowercasedWord = word.lowercased()

        customExceptionsLock.lock()
        guard let locations = customExceptions[lowercasedWord] ?? defaultExceptions[lowercasedWord] else {
            customExceptionsLock.unlock()
            return nil
        }
        customExceptionsLock.unlock()

        var hyphenatedWord = word

        for location in locations.sorted().reversed() {
            hyphenatedWord.insert("-", at: location)
        }

        return hyphenatedWord
    }
}

// MARK: Methods

extension ExceptionDictionary {
    /// Adds custom exceptions to the dictionary.
    ///
    /// - Parameters:
    ///   - hyphenations: A collection of words to be treated as exceptions, with hyphens ("-") inserted
    ///      at the desired hyphenation points.
    func addCustomExceptions<T: Collection>(_ hyphenations: T) where T.Element == String {
        customExceptionsLock.lock()
        hyphenations.map(Exception.init).forEach { exception in
            customExceptions[exception.identifier] = exception.locations
        }
        customExceptionsLock.unlock()
    }

    /// Removes custom exceptions from the dictionary.
    ///
    /// - Parameters:
    ///   - exceptions: A collection of words that should not have custom hyphenation exceptions.
    func removeCustomExceptions<T: Collection>(_ exceptions: T) where T.Element == String {
        customExceptionsLock.lock()
        exceptions.map(Exception.init).forEach { exception in
            customExceptions[exception.identifier] = nil
        }
        customExceptionsLock.unlock()
    }

    /// Removes all custom exceptions from the dictionary.
    func removeAllCustomExceptions() {
        customExceptionsLock.lock()
        customExceptions = [:]
        customExceptionsLock.unlock()
    }
}

// MARK: Default exceptions

extension ExceptionDictionary {
    /// A URL refering to a file containing the default English exceptions.
    private static let defaultFileURL = URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent("Patterns/hyph-en-us.hyp.txt")

    /// An `ExceptionDictionary` containing the default English exceptions.
    private static var defaultDictionary = try! ExceptionDictionary(fileURL: defaultFileURL)
    // swiftlint:disable:previous force_try
}
