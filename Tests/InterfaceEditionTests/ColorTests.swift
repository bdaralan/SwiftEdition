import XCTest
import SwiftUI
@testable import InterfaceEdition


final class ColorTests: XCTestCase {
    
    func testInitHex() {
        XCTAssertNotNil(UIColor(hex: "BDA12A"))
        
        XCTAssertNotNil(Color(hex: "BDA12A"))
        
        XCTAssertNil(UIColor(hex: "#BDA12A"))
        
        XCTAssertNotNil(Color(hex: "#BDA12A"))
    }
}
