import UIKit


extension UIStackView {
    
    public convenience init(_ axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0, views: [UIView]) {
        self.init()
        self.axis = axis
        self.spacing = spacing
        views.forEach(addArrangedSubview)
    }
    
    public convenience init(_ axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0, views: UIView...) {
        self.init()
        self.axis = axis
        self.spacing = spacing
        views.forEach(addArrangedSubview)
    }
}


extension UIStackView {
    
    public func setArrangedSubviews(_ views: [UIView]) {
        arrangedSubviews.forEach({ $0.removeFromSuperview() })
        views.forEach(addArrangedSubview)
    }
    
    public func setArrangedSubviews(_ views: UIView...) {
        arrangedSubviews.forEach({ $0.removeFromSuperview() })
        views.forEach(addArrangedSubview)
    }
    
    public func removeArrangedSubviews() {
        arrangedSubviews.forEach({ $0.removeFromSuperview() })
    }
}


extension UIStackView {
    
    public var padding: NSDirectionalEdgeInsets {
        get { directionalLayoutMargins }
        set {
            isLayoutMarginsRelativeArrangement = newValue != .zero
            directionalLayoutMargins = newValue
        }
    }
}


extension NSDirectionalEdgeInsets {
    
    public init(vertical: CGFloat = 0, horizontal: CGFloat = 0) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
    
    public init(_ all: CGFloat) {
        self.init(top: all, leading: all, bottom: all, trailing: all)
    }
}
