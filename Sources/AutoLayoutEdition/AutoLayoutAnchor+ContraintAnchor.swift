import UIKit


// MARK: - Protocol & Extension

public protocol AutoLayoutConstraintAnchor {
    
    var constraint: NSLayoutConstraint? { get }
}


extension AutoLayoutConstraintAnchor {
    
    /// Set the constraint's active state.
    public func activate(_ active: Bool) {
        constraint?.isActive = active
    }
}


extension Array where Element == AutoLayoutConstraintAnchor {
    
    /// Set the constraints' active state.
    public func activate(_ active: Bool) {
        let constraints = compactMap(\.constraint)
        if active {
            NSLayoutConstraint.activate(constraints)
        } else {
            NSLayoutConstraint.deactivate(constraints)
        }
    }
}


// MARK: - Typealias

public typealias AutoLayoutXAxisAnchor = AutoLayoutAnchor.Anchor<AutoLayoutAnchor.XAxisAnchor>

public typealias AutoLayoutYAxisAnchor = AutoLayoutAnchor.Anchor<AutoLayoutAnchor.YAxisAnchor>

public typealias AutoLayoutDimensionAnchor = AutoLayoutAnchor.Anchor<AutoLayoutAnchor.DimensionAnchor>
