import XCTest
@testable import BuilderEdition


final class ObjectBuilderTests: XCTestCase {
    
    func testArrayMethod() {
        let array = ObjectBuilder.array {
            "A"
            "B"
            "C"
        }
        XCTAssertEqual(array, ["A", "B", "C"])
    }
    
    func testSetMethod() {
        let set = ObjectBuilder.set {
            "A"
            "B"
            "C"
            "A"
            "B"
            "C"
        }
        XCTAssertEqual(set, ["A", "B", "C"])
    }
}
