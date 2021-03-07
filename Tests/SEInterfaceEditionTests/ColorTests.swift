import XCTest
import SwiftUI
@testable import SEInterfaceEdition


final class ColorTests: XCTestCase {
    
    func testInitHex() {
        XCTAssertNotNil(UIColor(hex: "BDA12A"))
        
        XCTAssertNotNil(Color(hex: "BDA12A"))
        
        XCTAssertNil(UIColor(hex: "#BDA12A"))
        
        XCTAssertNotNil(Color(hex: "#BDA12A"))
    }
}
