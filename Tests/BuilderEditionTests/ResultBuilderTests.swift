import XCTest
@testable import BuilderEdition


final class ResultBuilderTests: XCTestCase {
    
    func testArrayMethod() {
        let array = ResultBuilder.array {
            "A"
            "B"
            "C"
        }
        XCTAssertEqual(array, ["A", "B", "C"])
    }
    
    func testSetMethod() {
        let set = ResultBuilder.set {
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
