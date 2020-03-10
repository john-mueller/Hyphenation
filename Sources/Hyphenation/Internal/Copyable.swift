// Hyphenation
// © 2020 John Mueller
// MIT license, see LICENSE.md for details

/// A type that can create a copy of an existing instance.
internal protocol Copyable {
    /// Creates a new instance of a `Copyable` class, copied from an existing instance.
    ///
    /// - Parameters:
    ///   - copy: The instance which will be copied.
    init(copy: Self)
    /// Returns a new instance of a `Copyable` class, copied from an existing instance.
    func copy() -> Self
}

extension Copyable {
    /// Returns a new instance of a `Copyable` class by passing an existing instance to `init(copy:)`.
    func copy() -> Self {
        Self(copy: self)
    }
}
