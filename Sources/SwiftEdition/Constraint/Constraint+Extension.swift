import UIKit


public extension NSLayoutConstraint {
    
    @discardableResult
    func activate(_ active: Bool = true) -> NSLayoutConstraint {
        isActive = active
        return self
    }
    
    @discardableResult
    func priority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
    
    @discardableResult
    func assign(to variable: inout NSLayoutConstraint?) -> NSLayoutConstraint {
        variable = self
        return self
    }
    
    @discardableResult
    func store(in array: inout [NSLayoutConstraint]) -> NSLayoutConstraint {
        array.append(self)
        return self
    }
}


public extension UIView {
    
    func addSubview(_ view: UIView, useAutoLayout: Bool) {
        view.translatesAutoresizingMaskIntoConstraints = !useAutoLayout
        addSubview(view)
    }
    
    @discardableResult
    func constraint(fill view: UIView, padding: NSDirectionalEdgeInsets = .zero) -> (top: NSLayoutConstraint, leading: NSLayoutConstraint, bottom: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let top = topAnchor.constraint(equalTo: view.topAnchor, constant: padding.top)
        let leading = leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding.leading)
        let bottom = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding.bottom)
        let trailing = trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding.trailing)
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
        return (top, leading, bottom, trailing)
    }
    
    @discardableResult
    func constraint(fill guide: UILayoutGuide, padding: NSDirectionalEdgeInsets = .zero) -> (top: NSLayoutConstraint, leading: NSLayoutConstraint, bottom: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let top = topAnchor.constraint(equalTo: guide.topAnchor, constant: padding.top)
        let leading = leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: padding.leading)
        let bottom = bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -padding.bottom)
        let trailing = trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -padding.trailing)
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
        return (top, leading, bottom, trailing)
    }
}
