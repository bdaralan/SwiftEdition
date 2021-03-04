import XCTest
@testable import SwiftEdition

final class SwiftEditionTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftEdition().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
