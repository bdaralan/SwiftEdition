import XCTest
@testable import AutoLayoutEdition


final class AutoLayoutAnchorTests: XCTestCase {
    
    var controller = UIViewController()
    var canvas: UIView { controller.view }
    var view1 = UIView()
    var view2 = UIView()
    var view3 = UIView()
    var view4 = UIView()
    
    override func setUp() {
        super.setUp()
        controller = UIViewController()
        view1 = UIView()
        view2 = UIView()
        view3 = UIView()
        view4 = UIView()
        
        canvas.addSubview(view1)
        canvas.addSubview(view2)
        canvas.addSubview(view3)
        canvas.addSubview(view4)
    }
    
    func testStoreInVariable() {
        var leading: AutoLayoutConstraintAnchor!
        
        view1.anchor.leading.equalTo(canvas).storeIn(&leading)
        
        XCTAssertNotNil(leading)
    }
    
    func testStoreInArray() {
        var constraints: [AutoLayoutConstraintAnchor] = []
        
        view1.anchor.leading.equalTo(canvas).storeIn(&constraints)
        view2.anchor.leading.equalTo(canvas).storeIn(&constraints)
        view3.anchor.leading.equalTo(canvas).storeIn(&constraints)
        view4.anchor.leading.equalTo(canvas).storeIn(&constraints)
        
        XCTAssertEqual(constraints.count, 4)
        XCTAssertTrue(constraints[0].constraint !== constraints[1].constraint)
        XCTAssertTrue(constraints[1].constraint !== constraints[2].constraint)
        XCTAssertTrue(constraints[2].constraint !== constraints[3].constraint)
    }
    
    func testPriority() {
        var constraints: [AutoLayoutConstraintAnchor] = []
        
        view1.anchor.leading.equalTo(canvas).priority(.low).storeIn(&constraints)
        view2.anchor.leading.equalTo(canvas).priority(.high).storeIn(&constraints)
        view3.anchor.leading.equalTo(canvas).priority(.required).storeIn(&constraints)
        view4.anchor.leading.equalTo(canvas).storeIn(&constraints)
        
        XCTAssertEqual(constraints.count, 4)
        XCTAssertTrue(constraints[0].constraint?.priority == .defaultLow)
        XCTAssertTrue(constraints[1].constraint?.priority == .defaultHigh)
        XCTAssertTrue(constraints[2].constraint?.priority == .required)
        XCTAssertTrue(constraints[3].constraint?.priority == .required)
    }
    
    func testTopBottomLeadingTrailingToView() {
        view1.anchor.top.equalTo(canvas)
        view2.anchor.bottom.equalTo(canvas)
        view3.anchor.leading.equalTo(canvas)
        view4.anchor.trailing.equalTo(canvas)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.frame.minY, canvas.frame.minY)
        XCTAssertEqual(view2.frame.maxY, canvas.frame.maxY)
        XCTAssertEqual(view3.frame.minX, canvas.frame.minX)
        XCTAssertEqual(view4.frame.maxX, canvas.frame.maxX)
    }
    
    func testTopBottomLeadingTrailingToViewPadding() {
        view1.anchor.top.equalTo(canvas).padding(10)
        view2.anchor.bottom.equalTo(canvas).padding(10).padding(20)
        view3.anchor.leading.equalTo(canvas).padding(30)
        view4.anchor.trailing.equalTo(canvas).padding(40).padding(-40)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.frame.minY, canvas.frame.minY + 10)
        XCTAssertEqual(view2.frame.maxY, canvas.frame.maxY - 20)
        XCTAssertEqual(view3.frame.minX, canvas.frame.minX + 30)
        XCTAssertEqual(view4.frame.maxX, canvas.frame.maxX + 40)
    }
    
    func testTopBottomLeadingTrailingToGuide() {
        view1.anchor.top.equalTo(canvas.safeAreaLayoutGuide)
        view2.anchor.bottom.equalTo(canvas.safeAreaLayoutGuide)
        view3.anchor.leading.equalTo(canvas.safeAreaLayoutGuide)
        view4.anchor.trailing.equalTo(canvas.safeAreaLayoutGuide)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.frame.minY, canvas.frame.minY)
        XCTAssertEqual(view2.frame.maxY, canvas.frame.maxY)
        XCTAssertEqual(view3.frame.minX, canvas.frame.minX)
        XCTAssertEqual(view4.frame.maxX, canvas.frame.maxX)
    }
    
    func testTopBottomLeadingTrailingToGuidePadding() {
        view1.anchor.top.equalTo(canvas.safeAreaLayoutGuide).padding(10)
        view2.anchor.bottom.equalTo(canvas.safeAreaLayoutGuide).padding(10).padding(20)
        view3.anchor.leading.equalTo(canvas.safeAreaLayoutGuide).padding(30)
        view4.anchor.trailing.equalTo(canvas.safeAreaLayoutGuide).padding(40).padding(-40)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.frame.minY, canvas.frame.minY + 10)
        XCTAssertEqual(view2.frame.maxY, canvas.frame.maxY - 20)
        XCTAssertEqual(view3.frame.minX, canvas.frame.minX + 30)
        XCTAssertEqual(view4.frame.maxX, canvas.frame.maxX + 40)
    }
    
    func testCenterXYToView() {
        view1.anchor.centerX.equalTo(canvas)
        view1.anchor.centerY.equalTo(canvas)
        view2.anchor.centerX.equalTo(canvas)
        view2.anchor.centerY.equalTo(canvas)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.center, view2.center)
    }
    
    func testCenterXYToViewPadding() {
        view1.anchor.centerX.equalTo(canvas).padding(10)
        view1.anchor.centerY.equalTo(canvas).padding(20)
        view2.anchor.centerX.equalTo(canvas).padding(10)
        view2.anchor.centerY.equalTo(canvas).padding(20)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.center, view2.center)
    }
    
    func testCenterXYToGuide() {
        view1.anchor.centerX.equalTo(canvas.safeAreaLayoutGuide)
        view1.anchor.centerY.equalTo(canvas.safeAreaLayoutGuide)
        view2.anchor.centerX.equalTo(canvas.safeAreaLayoutGuide)
        view2.anchor.centerY.equalTo(canvas.safeAreaLayoutGuide)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.center, view2.center)
    }
    
    func testCenterXYToGuidePadding() {
        view1.anchor.centerX.equalTo(canvas.safeAreaLayoutGuide).padding(10)
        view1.anchor.centerY.equalTo(canvas.safeAreaLayoutGuide).padding(20)
        view2.anchor.centerX.equalTo(canvas.safeAreaLayoutGuide).padding(10)
        view2.anchor.centerY.equalTo(canvas.safeAreaLayoutGuide).padding(20)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.center, view2.center)
    }
    
    func testWidthHeightToView() {
        view1.anchor.width.equalTo(canvas)
        view1.anchor.height.equalTo(canvas)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.bounds.width, canvas.bounds.width)
        XCTAssertEqual(view1.bounds.height, canvas.bounds.height)
    }
    
    func testWidthHeightToViewAddSubtract() {
        view1.anchor.width.equalTo(canvas).add(10)
        view1.anchor.height.equalTo(canvas).subtract(10)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.bounds.width, canvas.bounds.width + 10)
        XCTAssertEqual(view1.bounds.height, canvas.bounds.height - 10)
    }
    
    func testWidthHeightToGuide() {
        view1.anchor.width.equalTo(canvas.safeAreaLayoutGuide)
        view1.anchor.height.equalTo(canvas.safeAreaLayoutGuide)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.bounds.width, canvas.bounds.width)
        XCTAssertEqual(view1.bounds.height, canvas.bounds.height)
    }
    
    func testWidthHeightToGuideAddSubtract() {
        view1.anchor.width.equalTo(canvas.safeAreaLayoutGuide).add(10)
        view1.anchor.height.equalTo(canvas.safeAreaLayoutGuide).subtract(10)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.bounds.width, canvas.bounds.width + 10)
        XCTAssertEqual(view1.bounds.height, canvas.bounds.height - 10)
    }
    
    func testWidthHeightToConstant() {
        view1.anchor.width.equalTo(400)
        view1.anchor.height.equalTo(400)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.bounds.width, 400)
        XCTAssertEqual(view1.bounds.height, 400)
    }
    
    func testWidthHeightConstantAddSubtract() {
        view1.anchor.width.equalTo(400).add(10).add(10)
        view1.anchor.height.equalTo(400).add(10).subtract(20).add(10)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.bounds.width, 420)
        XCTAssertEqual(view1.bounds.height, 400)
    }
    
    func testWidthHeightMultiplier() {
        view1.anchor.width.equalTo(400)
        view1.anchor.height.equalTo(400)
        
        view2.anchor.width.equalTo(view1).multiplier(1/2)
        view2.anchor.height.equalTo(view1).multiplier(1/4)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.bounds.width, 400)
        XCTAssertEqual(view1.bounds.height, 400)
        
        XCTAssertEqual(view2.bounds.width, 200)
        XCTAssertEqual(view2.bounds.height, 100)
    }
    
    func testWidthHeightMultiplierAddSubtract() {
        view1.anchor.width.equalTo(400)
        view1.anchor.height.equalTo(400)
        
        view2.anchor.width.equalTo(view1).multiplier(1/2).add(10)
        view2.anchor.height.equalTo(view1).multiplier(1/4).subtract(20)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.bounds.width, 400)
        XCTAssertEqual(view1.bounds.height, 400)
        
        XCTAssertEqual(view2.bounds.width, 210)
        XCTAssertEqual(view2.bounds.height, 80)
    }
    
    func testPinToView() {
        view1.anchor.pinTo(canvas)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.bounds, canvas.bounds)
    }
    
    func testPinToViewPadding() {
        view1.anchor.pinTo(canvas).padding(top: 10)
        view2.anchor.pinTo(canvas).padding(bottom: 10)
        view3.anchor.pinTo(canvas).leading.padding(10)
        view4.anchor.pinTo(canvas).trailing.padding(10)
        
        canvas.layoutIfNeeded()
        
        XCTAssertTrue(view1.bounds.height < canvas.bounds.height)
        XCTAssertTrue(view2.bounds.height < canvas.bounds.height)
        XCTAssertTrue(view3.bounds.width < canvas.bounds.width)
        XCTAssertTrue(view4.bounds.width < canvas.bounds.width)
        
        XCTAssertEqual(view1.frame.minY - 10, canvas.frame.minY)
        XCTAssertEqual(view2.frame.maxY + 10, canvas.frame.maxY)
        XCTAssertEqual(view3.frame.minX - 10, canvas.frame.minX)
        XCTAssertEqual(view4.frame.maxX + 10, canvas.frame.maxX)
    }
    
    func testPinToGuide() {
        view1.anchor.pinTo(canvas.safeAreaLayoutGuide)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.frame, canvas.frame)
    }
    
    func testPinToGuidePadding() {
        view1.anchor.pinTo(canvas.safeAreaLayoutGuide).padding(top: 10)
        view2.anchor.pinTo(canvas.safeAreaLayoutGuide).padding(bottom: 10)
        view3.anchor.pinTo(canvas.safeAreaLayoutGuide).padding(leading: 10)
        view4.anchor.pinTo(canvas.safeAreaLayoutGuide).padding(trailing: 10)
        
        canvas.layoutIfNeeded()
        
        XCTAssertTrue(view1.bounds.height < canvas.bounds.height)
        XCTAssertTrue(view2.bounds.height < canvas.bounds.height)
        XCTAssertTrue(view3.bounds.width < canvas.bounds.width)
        XCTAssertTrue(view4.bounds.width < canvas.bounds.width)
        
        XCTAssertEqual(view1.frame.minY - 10, canvas.frame.minY)
        XCTAssertEqual(view2.frame.maxY + 10, canvas.frame.maxY)
        XCTAssertEqual(view3.frame.minX - 10, canvas.frame.minX)
        XCTAssertEqual(view4.frame.maxX + 10, canvas.frame.maxX)
    }
    
    func testPinToViewEdges() {
        view1.anchor.pinTo(canvas, [.top, .bottom, .leading, .trailing])
        view2.anchor.pinTo(canvas, [.top, .leading, .trailing])
        view3.anchor.pinTo(canvas, [.bottom, .leading])
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.frame, canvas.frame)

        XCTAssertEqual(view2.frame.minY, canvas.frame.minY)
        XCTAssertEqual(view2.frame.minX, canvas.frame.minX)
        XCTAssertEqual(view2.frame.maxX, canvas.frame.maxX)
        XCTAssertNotEqual(view2.frame.maxY, canvas.frame.maxY)
        
        XCTAssertEqual(view3.frame.maxY, canvas.frame.maxY)
        XCTAssertEqual(view3.frame.minX, canvas.frame.minX)
        XCTAssertNotEqual(view3.frame.minY, canvas.frame.minY)
        XCTAssertNotEqual(view3.frame.maxX, canvas.frame.maxX)
    }
    
    func testPinToViewEdgesPadding() {
        view1.anchor.pinTo(canvas, [.top, .bottom, .leading, .trailing]).padding(edges: 10)
        view2.anchor.pinTo(canvas, [.top, .leading, .trailing]).padding(edges: 20)
        view3.anchor.pinTo(canvas, [.bottom, .leading]).padding(edges: 30)
        
        canvas.layoutIfNeeded()
        
        XCTAssertNotEqual(view1.frame, canvas.frame)
        XCTAssertEqual(view1.frame.minY, canvas.frame.minY + 10)
        XCTAssertEqual(view1.frame.maxY, canvas.frame.maxY - 10)
        XCTAssertEqual(view1.frame.minX, canvas.frame.minX + 10)
        XCTAssertEqual(view1.frame.maxX, canvas.frame.maxX - 10)
        XCTAssertEqual(view1.bounds.width, canvas.bounds.width - 20)
        XCTAssertEqual(view1.bounds.height, canvas.bounds.height - 20)

        XCTAssertNotEqual(view2.frame, canvas.frame)
        XCTAssertEqual(view2.frame.minY, canvas.frame.minY + 20)
        XCTAssertEqual(view2.frame.minX, canvas.frame.minX + 20)
        XCTAssertEqual(view2.frame.maxX, canvas.frame.maxX - 20)
        XCTAssertNotEqual(view2.frame.maxY, canvas.frame.maxY - 20)
        XCTAssertEqual(view2.bounds.width, canvas.bounds.width - 40)
        XCTAssertNotEqual(view2.bounds.height, canvas.bounds.height - 40)
        
        XCTAssertNotEqual(view3.frame, canvas.frame)
        XCTAssertEqual(view3.frame.maxY, canvas.frame.maxY - 30)
        XCTAssertEqual(view3.frame.minX, canvas.frame.minX + 30)
        XCTAssertNotEqual(view3.frame.minY, canvas.frame.minY + 30)
        XCTAssertNotEqual(view3.frame.maxX, canvas.frame.maxX - 30)
        XCTAssertNotEqual(view3.bounds.width, canvas.bounds.width - 60)
        XCTAssertNotEqual(view3.bounds.height, canvas.bounds.height - 60)
    }
    
    func testPinToGuideEdges() {
        view1.anchor.pinTo(canvas.safeAreaLayoutGuide, [.top, .bottom, .leading, .trailing])
        view2.anchor.pinTo(canvas.safeAreaLayoutGuide, [.top, .leading, .trailing])
        view3.anchor.pinTo(canvas.safeAreaLayoutGuide, [.bottom, .leading])
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.frame, canvas.frame)

        XCTAssertEqual(view2.frame.minY, canvas.frame.minY)
        XCTAssertEqual(view2.frame.minX, canvas.frame.minX)
        XCTAssertEqual(view2.frame.maxX, canvas.frame.maxX)
        XCTAssertNotEqual(view2.frame.maxY, canvas.frame.maxY)
        
        XCTAssertEqual(view3.frame.maxY, canvas.frame.maxY)
        XCTAssertEqual(view3.frame.minX, canvas.frame.minX)
        XCTAssertNotEqual(view3.frame.minY, canvas.frame.minY)
        XCTAssertNotEqual(view3.frame.maxX, canvas.frame.maxX)
    }
    
    func testPinToGuideEdgesPadding() {
        view1.anchor.pinTo(canvas.safeAreaLayoutGuide, [.top, .bottom, .leading, .trailing]).padding(edges: 10)
        view2.anchor.pinTo(canvas.safeAreaLayoutGuide, [.top, .leading, .trailing]).padding(edges: 20)
        view3.anchor.pinTo(canvas.safeAreaLayoutGuide, [.bottom, .leading]).padding(edges: 30)
        
        canvas.layoutIfNeeded()
        
        XCTAssertNotEqual(view1.frame, canvas.frame)
        XCTAssertEqual(view1.frame.minY, canvas.frame.minY + 10)
        XCTAssertEqual(view1.frame.maxY, canvas.frame.maxY - 10)
        XCTAssertEqual(view1.frame.minX, canvas.frame.minX + 10)
        XCTAssertEqual(view1.frame.maxX, canvas.frame.maxX - 10)
        XCTAssertEqual(view1.bounds.width, canvas.bounds.width - 20)
        XCTAssertEqual(view1.bounds.height, canvas.bounds.height - 20)

        XCTAssertNotEqual(view2.frame, canvas.frame)
        XCTAssertEqual(view2.frame.minY, canvas.frame.minY + 20)
        XCTAssertEqual(view2.frame.minX, canvas.frame.minX + 20)
        XCTAssertEqual(view2.frame.maxX, canvas.frame.maxX - 20)
        XCTAssertNotEqual(view2.frame.maxY, canvas.frame.maxY - 20)
        XCTAssertEqual(view2.bounds.width, canvas.bounds.width - 40)
        XCTAssertNotEqual(view2.bounds.height, canvas.bounds.height - 40)
        
        XCTAssertNotEqual(view3.frame, canvas.frame)
        XCTAssertEqual(view3.frame.maxY, canvas.frame.maxY - 30)
        XCTAssertEqual(view3.frame.minX, canvas.frame.minX + 30)
        XCTAssertNotEqual(view3.frame.minY, canvas.frame.minY + 30)
        XCTAssertNotEqual(view3.frame.maxX, canvas.frame.maxX - 30)
        XCTAssertNotEqual(view3.bounds.width, canvas.bounds.width - 60)
        XCTAssertNotEqual(view3.bounds.height, canvas.bounds.height - 60)
    }
    
    func testSizeToView() {
        view1.anchor.sizeTo(canvas)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.bounds.width, canvas.bounds.width)
        XCTAssertEqual(view1.bounds.height, canvas.bounds.height)
    }
    
    func testSizeToViewAddSubtract() {
        view1.anchor.sizeTo(canvas).add(width: 20, height: 20)
        view2.anchor.sizeTo(canvas).subtract(width: 20, height: 20)
        
        view3.anchor { anchor in
            anchor.sizeTo(canvas)
            anchor.width.add(10).subtract(20).add(10)
            anchor.height.add(10).add(10).subtract(20)
        }
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.bounds.width, canvas.bounds.width + 20)
        XCTAssertEqual(view1.bounds.height, canvas.bounds.height + 20)
        
        XCTAssertEqual(view2.bounds.width, canvas.bounds.width - 20)
        XCTAssertEqual(view2.bounds.height, canvas.bounds.height - 20)
        
        XCTAssertEqual(view3.bounds.width, canvas.bounds.width)
        XCTAssertEqual(view3.bounds.height, canvas.bounds.height)
    }
    
    func testSizeToGuide() {
        view1.anchor.sizeTo(canvas.safeAreaLayoutGuide)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.bounds.width, canvas.bounds.width)
        XCTAssertEqual(view1.bounds.height, canvas.bounds.height)
    }
    
    func testSizeToGuideAddSubtract() {
        view1.anchor.sizeTo(canvas.safeAreaLayoutGuide).add(width: 20, height: 20)
        view2.anchor.sizeTo(canvas.safeAreaLayoutGuide).subtract(width: 20, height: 20)
        
        view3.anchor { anchor in
            anchor.sizeTo(canvas.safeAreaLayoutGuide)
            anchor.width.add(10).subtract(20).add(10)
            anchor.height.add(10).add(10).subtract(20)
        }
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.bounds.width, canvas.bounds.width + 20)
        XCTAssertEqual(view1.bounds.height, canvas.bounds.height + 20)
        
        XCTAssertEqual(view2.bounds.width, canvas.bounds.width - 20)
        XCTAssertEqual(view2.bounds.height, canvas.bounds.height - 20)
        
        XCTAssertEqual(view3.bounds.width, canvas.bounds.width)
        XCTAssertEqual(view3.bounds.height, canvas.bounds.height)
    }
    
    func testCenterToView() {
        view1.anchor.centerTo(canvas)
        view1.anchor.width.equalTo(100)
        view1.anchor.height.equalTo(100)
        
        view2.anchor.centerTo(canvas)
        view2.anchor.width.equalTo(100)
        view2.anchor.height.equalTo(100)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.center, view2.center)
    }
    
    func testCenterToViewPadding() {
        view1.anchor.centerTo(canvas).padding(centerX: 10, centerY: 10)
        view1.anchor.width.equalTo(100)
        view1.anchor.height.equalTo(100)
        
        view2.anchor.centerTo(canvas).padding(centerX: 10, centerY: 10)
        view2.anchor.width.equalTo(100)
        view2.anchor.height.equalTo(100)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.center, view2.center)
    }
    
    func testCenterToGuide() {
        view1.anchor.centerTo(canvas.safeAreaLayoutGuide)
        view1.anchor.width.equalTo(100)
        view1.anchor.height.equalTo(100)
        
        view2.anchor.centerTo(canvas.safeAreaLayoutGuide)
        view2.anchor.width.equalTo(100)
        view2.anchor.height.equalTo(100)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.center, view2.center)
    }
    
    func testCenterToGuidePadding() {
        view1.anchor.centerTo(canvas.safeAreaLayoutGuide).padding(centerX: 10, centerY: 10)
        view1.anchor.width.equalTo(100)
        view1.anchor.height.equalTo(100)
        
        view2.anchor.centerTo(canvas.safeAreaLayoutGuide).padding(centerX: 10, centerY: 10)
        view2.anchor.width.equalTo(100)
        view2.anchor.height.equalTo(100)
        
        canvas.layoutIfNeeded()
        
        XCTAssertEqual(view1.center, view2.center)
    }
}
