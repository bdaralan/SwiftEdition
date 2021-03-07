import XCTest
@testable import SEInterfaceEdition


final class StackViewTests: XCTestCase {
    
    var view01 = UIView()
    var view02 = UIView()
    var view03 = UIView()
    var view04 = UIView()
    var views = [UIView]()
    
    override func setUp() {
        super.setUp()
        view01 = UIView()
        view02 = UIView()
        view03 = UIView()
        view04 = UIView()
        views = [view01, view02, view03, view04]
    }
    
    func testInitArrayViews() {
        let stack = UIStackView(.horizontal, spacing: 4, views: views)
        
        XCTAssertEqual(stack.axis, .horizontal)
        XCTAssertEqual(stack.spacing, 4)
        XCTAssertEqual(stack.arrangedSubviews, views)
    }
    
    func testInitVariadicViews() {
        let stack = UIStackView(.vertical, spacing: 9, views: view01, view02, view03, view04)
        
        XCTAssertEqual(stack.axis, .vertical)
        XCTAssertEqual(stack.spacing, 9)
        XCTAssertEqual(stack.arrangedSubviews, [view01, view02, view03, view04])
    }
    
    func testSetArrayArrangedSubviews() {
        let stack = UIStackView()
        
        XCTAssertTrue(stack.arrangedSubviews.isEmpty)
        
        stack.setArrangedSubviews(views)
        
        XCTAssertEqual(stack.arrangedSubviews, views)
    }
    
    func testSetVariadicArrangedSubviews() {
        let stack = UIStackView()
        
        XCTAssertTrue(stack.arrangedSubviews.isEmpty)
        
        stack.setArrangedSubviews(view01, view02, view03, view04)
        
        XCTAssertEqual(stack.arrangedSubviews, views)
    }
    
    func testRemoveArrangedSubviews() {
        let stack = UIStackView(.vertical, views: views)
        
        XCTAssertEqual(stack.arrangedSubviews, views)
        
        stack.removeArrangedSubviews()
        
        XCTAssertTrue(stack.arrangedSubviews.isEmpty)
    }
    
    func testPadding() {
        let stack = UIStackView()
        let padding = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 30, trailing: 40)
        
        XCTAssertEqual(stack.isLayoutMarginsRelativeArrangement, false)
        XCTAssertEqual(stack.directionalLayoutMargins, .zero)
        XCTAssertEqual(stack.padding, .zero)
        
        stack.padding = padding
        
        XCTAssertEqual(stack.isLayoutMarginsRelativeArrangement, true)
        XCTAssertEqual(stack.directionalLayoutMargins, padding)
        XCTAssertEqual(stack.padding, padding)
        
        stack.padding = .zero
        
        XCTAssertEqual(stack.isLayoutMarginsRelativeArrangement, false)
        XCTAssertEqual(stack.directionalLayoutMargins, .zero)
        XCTAssertEqual(stack.padding, .zero)
    }
}
