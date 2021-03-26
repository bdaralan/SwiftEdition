import XCTest
@testable import InterfaceEdition


final class ConstraintTests: XCTestCase {
    
    var superview = UIView()
    var subview = UIView()
    
    override func setUp() {
        super.setUp()
        superview = UIView(frame: CGRect(x: 0, y: 0, width: 900, height: 400))
        subview = UIView()
        superview.addSubview(subview)
    }
    
    func testConstraintFillSuperview() {
        subview.constraint(fill: superview)
        
        superview.layoutIfNeeded()
        
        XCTAssertEqual(subview.bounds, superview.bounds)
    }
    
    func testConstraintFillGuide() {
        subview.constraint(fill: superview.safeAreaLayoutGuide)
        
        superview.layoutIfNeeded()
        
        XCTAssertEqual(subview.frame, superview.frame)
    }
    
    func testConstraintCenterSuperview() {
        subview.constraint(center: superview)
        
        superview.layoutIfNeeded()
        
        XCTAssertEqual(subview.center, superview.center)
    }
    
    func testConstraintCenterGuide() {
        subview.constraint(center: superview.safeAreaLayoutGuide)
        
        superview.layoutIfNeeded()
        
        XCTAssertEqual(subview.center, superview.center)
    }
    
    func testAnchorTopBottomLeadingTrailingSuperview() {
        subview.anchor.top.equalTo(superview)
        subview.anchor.bottom.equalTo(superview)
        subview.anchor.leading.equalTo(superview)
        subview.anchor.trailing.equalTo(superview)
        
        superview.layoutIfNeeded()
        
        XCTAssertEqual(subview.frame, superview.frame)
    }
    
    func testAnchorWidthHeightSuperview() {
        subview.anchor.width.equalTo(superview)
        subview.anchor.height.equalTo(superview)
        
        superview.layoutIfNeeded()
        
        XCTAssertEqual(subview.bounds, superview.bounds)
    }
    
    func testAnchorWidthHeightPaddingSuperview() {
        subview.anchor.width.equalTo(superview).padding(10)
        subview.anchor.height.equalTo(superview).padding(10)
        
        superview.layoutIfNeeded()
        
        XCTAssertNotEqual(subview.frame, superview.frame)
        XCTAssertEqual(subview.bounds.width, superview.bounds.width - 20)
        XCTAssertEqual(subview.bounds.height, superview.bounds.height - 20)
    }
    
    func testAnchorWidthHeightMultiplierPaddingSuperview() {
        subview.anchor.width.equalTo(superview).multiplier(1/2).padding(10)
        subview.anchor.height.equalTo(superview).multiplier(1/2).padding(10)
        
        superview.layoutIfNeeded()
        
        XCTAssertNotEqual(subview.frame, superview.frame)
        XCTAssertEqual(subview.bounds.width, superview.bounds.width / 2 - 20)
        XCTAssertEqual(subview.bounds.height, superview.bounds.height / 2 - 20)
    }
    
    func testAnchorCenterXYSuperview() {
        subview.anchor.centerX.equalTo(superview)
        subview.anchor.centerY.equalTo(superview)
        
        superview.layoutIfNeeded()
        
        XCTAssertNotEqual(subview.frame, superview.frame)
        XCTAssertEqual(subview.center, superview.center)
    }
    
    func testAnchorTopBottomLeadingTrailingAnchor() {
        subview.anchor.top.equalTo(superview.anchor.top)
        subview.anchor.bottom.equalTo(superview.anchor.bottom)
        subview.anchor.leading.equalTo(superview.anchor.leading)
        subview.anchor.trailing.equalTo(superview.anchor.trailing)
        
        superview.layoutIfNeeded()
        
        XCTAssertEqual(subview.frame, superview.frame)
    }
    
    func testAnchorWidthHeightAnchor() {
        subview.anchor.width.equalTo(superview.anchor.width)
        subview.anchor.height.equalTo(superview.anchor.height)
        
        superview.layoutIfNeeded()
        
        XCTAssertEqual(subview.bounds, superview.bounds)
    }
    
    func testAnchorWidthHeightPaddingAnchor() {
        subview.anchor.width.equalTo(superview.anchor.width).padding(10)
        subview.anchor.height.equalTo(superview.anchor.height).padding(10)
        
        superview.layoutIfNeeded()
        
        XCTAssertNotEqual(subview.frame, superview.frame)
        XCTAssertEqual(subview.bounds.width, superview.bounds.width - 20)
        XCTAssertEqual(subview.bounds.height, superview.bounds.height - 20)
    }
    
    func testAnchorCenterXYAnchor() {
        subview.anchor.centerX.equalTo(superview.anchor.centerX)
        subview.anchor.centerY.equalTo(superview.anchor.centerY)
        
        superview.layoutIfNeeded()
        
        XCTAssertNotEqual(subview.frame, superview.frame)
        XCTAssertEqual(subview.center, superview.center)
    }
    
    func testConstraintAnchorTopBottomLeadingTrailingSuperview() {
        subview.constraint { anchor in
            anchor.top.equalTo(superview)
            anchor.bottom.equalTo(superview)
            anchor.leading.equalTo(superview)
            anchor.trailing.equalTo(superview)
        }
        
        superview.layoutIfNeeded()
        
        XCTAssertEqual(subview.frame, superview.frame)
    }
    
    func testConstraintAnchorTopBottomLeadingTrailingAnchor() {
        subview.constraint { anchor in
            anchor.top.equalTo(superview.anchor.top)
            anchor.bottom.equalTo(superview.anchor.bottom)
            anchor.leading.equalTo(superview.anchor.leading)
            anchor.trailing.equalTo(superview.anchor.trailing)
        }
        
        superview.layoutIfNeeded()
        
        XCTAssertEqual(subview.frame, superview.frame)
    }
}
