import XCTest
@testable import AutoLayoutEdition


final class AutoLayoutAnchorTests: XCTestCase {
    
    var superview = UIView()
    var subview = UIView()
    
    override func setUp() {
        super.setUp()
        superview = UIView(frame: CGRect(x: 0, y: 0, width: 900, height: 400))
        subview = UIView()
        superview.addSubview(subview)
    }
    
    func testAnchorPinToSuperview() {
        subview.anchor.pinTo(superview)
        
        superview.layoutIfNeeded()
        
        XCTAssertEqual(subview.bounds, superview.bounds)
    }
    
    func testCallAnchorPinToSuperviewAndCallAnchorPaddingDoesNotWork() {
        subview.anchor.pinTo(superview)
        subview.anchor.leading.padding(10)
        
        superview.layoutIfNeeded()
        
        XCTAssertFalse(subview.bounds.width < superview.bounds.width)
        XCTAssertEqual(subview.bounds, superview.bounds)
    }
    
    func testAnchorPinToSuperviewPadding() {
        subview.anchor { anchor in
            anchor.pinTo(superview)
            anchor.leading.padding(10)
        }
        
        superview.layoutIfNeeded()
        
        XCTAssertTrue(subview.bounds.width < superview.bounds.width)
        XCTAssertTrue(subview.bounds.width == superview.bounds.width - 10)
        XCTAssertEqual(subview.bounds.height, superview.bounds.height)
    }
    
    func testConstraintFillGuide() {
        subview.anchor.pinTo(superview.safeAreaLayoutGuide)
        
        superview.layoutIfNeeded()
        
        XCTAssertEqual(subview.frame, superview.frame)
    }
    
    func testConstraintCenterSuperview() {
        subview.anchor.centerTo(superview)
        
        superview.layoutIfNeeded()
        
        XCTAssertEqual(subview.center, superview.center)
    }
    
    func testConstraintCenterGuide() {
        subview.anchor.centerTo(superview.safeAreaLayoutGuide)
        
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
    
    func testAnchorCenterWidthHeightAddSubtractSuperview() {
        subview.anchor.centerX.equalTo(superview)
        subview.anchor.centerY.equalTo(superview)
        subview.anchor.width.equalTo(superview).subtract(50).add(40).subtract(10).subtract(20).add(10).add(10)
        subview.anchor.height.equalTo(superview).subtract(60).add(50).subtract(20).subtract(30).add(20).add(20)
        
        superview.layoutIfNeeded()
        
        XCTAssertNotEqual(subview.frame, superview.frame)
        XCTAssertEqual(subview.center, superview.center)
        XCTAssertEqual(subview.bounds.width, superview.bounds.width - 20)
        XCTAssertEqual(subview.bounds.height, superview.bounds.height - 20)
    }
    
    func testAnchorWidthHeightMultiplierPaddingSuperview() {
        subview.anchor.width.equalTo(superview).multiplier(1/2).subtract(10 * 2)
        subview.anchor.height.equalTo(superview).multiplier(1/2).subtract(10 * 2)
        
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
        subview.anchor.width.equalTo(superview.anchor.width).subtract(20)
        subview.anchor.height.equalTo(superview.anchor.height).subtract(20)
        
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
        subview.anchor { anchor in
            anchor.top.equalTo(superview)
            anchor.bottom.equalTo(superview)
            anchor.leading.equalTo(superview)
            anchor.trailing.equalTo(superview)
        }
        
        superview.layoutIfNeeded()
        
        XCTAssertEqual(subview.frame, superview.frame)
    }
    
    func testConstraintAnchorTopBottomLeadingTrailingAnchor() {
        subview.anchor { anchor in
            anchor.top.equalTo(superview.anchor.top)
            anchor.bottom.equalTo(superview.anchor.bottom)
            anchor.leading.equalTo(superview.anchor.leading)
            anchor.trailing.equalTo(superview.anchor.trailing)
        }
        
        superview.layoutIfNeeded()
        
        XCTAssertEqual(subview.frame, superview.frame)
    }
}
