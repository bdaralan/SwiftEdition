import XCTest
import SwiftUI
@testable import SwiftEdition


final class ColorTests: XCTestCase {
    
    func testInitHex() {
        XCTAssertNotNil(UIColor(hex: "BDA12A"))
        
        XCTAssertNotNil(Color(hex: "BDA12A"))
        
        XCTAssertNil(UIColor(hex: "#BDA12A"))
        
        XCTAssertNotNil(Color(hex: "#BDA12A"))
    }
    
    static var allTests = [
        ("testInitHex", testInitHex)
    ]
}
