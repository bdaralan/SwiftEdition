import XCTest
@testable import InterfaceEdition


final class ConstraintTests: XCTestCase {
    
    var superview = UIView()
    var subview = UIView()
    
    override func setUp() {
        super.setUp()
        superview = .init()
        subview = .init()
        superview.addSubview(subview)
    }
    
    func testActivateMethod() {
//        let constraint = subview.topAnchor.constraint(equalTo: superview.topAnchor)
//
//        constraint.activate()
//
//        XCTAssertEqual(constraint.isActive, true)
//
//        constraint.activate(false)
//
//        XCTAssertEqual(constraint.isActive, false)
    }
    
    func testPriorityMethod() {
//        let constraint = subview.topAnchor.constraint(equalTo: superview.topAnchor)
//
//        constraint.priority(.defaultLow)
//
//        XCTAssertEqual(constraint.priority, .defaultLow)
//
//        constraint.priority(.defaultHigh)
//
//        XCTAssertEqual(constraint.priority, .defaultHigh)
    }
    
    func testAssignMethod() {
//        var constraint: NSLayoutConstraint?
//        XCTAssertNil(constraint)
//        
//        subview.topAnchor.constraint(equalTo: superview.topAnchor).store(in: &constraint)
//        XCTAssertNotNil(constraint)
    }
}
