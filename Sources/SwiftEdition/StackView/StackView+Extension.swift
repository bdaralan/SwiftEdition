import UIKit


public extension UIStackView {
    
    convenience init(_ axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0, views: [UIView]) {
        self.init()
        self.axis = axis
        self.spacing = spacing
        views.forEach(addArrangedSubview)
    }
    
    convenience init(_ axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0, views: UIView...) {
        self.init()
        self.axis = axis
        self.spacing = spacing
        views.forEach(addArrangedSubview)
    }
}


public extension UIStackView {
    
    func setArrangedSubviews(_ views: [UIView]) {
        arrangedSubviews.forEach({ $0.removeFromSuperview() })
        views.forEach(addArrangedSubview)
    }
    
    func setArrangedSubviews(_ views: UIView...) {
        arrangedSubviews.forEach({ $0.removeFromSuperview() })
        views.forEach(addArrangedSubview)
    }
    
    func removeArrangedSubviews() {
        arrangedSubviews.forEach({ $0.removeFromSuperview() })
    }
}


public extension UIStackView {
    
    var padding: NSDirectionalEdgeInsets {
        get { directionalLayoutMargins }
        set {
            isLayoutMarginsRelativeArrangement = newValue != .zero
            directionalLayoutMargins = newValue
        }
    }
}


public extension NSDirectionalEdgeInsets {
    
    init(vertical: CGFloat = 0, horizontal: CGFloat = 0) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
    
    init(_ all: CGFloat) {
        self.init(top: all, leading: all, bottom: all, trailing: all)
    }
}
