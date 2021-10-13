// Hyphenation
// © 2019 John Sundell, © 2020 John Mueller
// MIT license, see LICENSE.md for details
//
// This extension is based on https://www.swiftbysundell.com/articles/testing-error-code-paths-in-swift/

import XCTest

extension XCTestCase {
    func assert<T, E: Error & Equatable>(
        _ expression: @autoclosure () throws -> T,
        throws error: E,
        in file: StaticString = #filePath,
        line: UInt = #line
    ) {
        var thrownError: Error?

        XCTAssertThrowsError(try expression(), file: file, line: line) {
            thrownError = $0
        }

        XCTAssertTrue(thrownError is E, "Unexpected error type: \(type(of: thrownError))", file: file, line: line)

        XCTAssertEqual(thrownError as? E, error, file: file, line: line)
    }
}
