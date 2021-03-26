import UIKit


public struct ConstraintAnchor {
    
    public let view: UIView
    
    public let leading: Anchor<XAxisAnchor>
    public let trailing: Anchor<XAxisAnchor>
    public let centerX: Anchor<XAxisAnchor>
    
    public let top: Anchor<YAxisAnchor>
    public let bottom: Anchor<YAxisAnchor>
    public let centerY: Anchor<YAxisAnchor>
    public let firstBaseline: Anchor<YAxisAnchor>
    public let lastBaseline: Anchor<YAxisAnchor>
    
    public let width: Anchor<DimensionAnchor>
    public let height: Anchor<DimensionAnchor>
    
    init(view: UIView) {
        self.view = view
        leading = .init(view: view, type: .leading)
        trailing = .init(view: view, type: .trailing)
        centerX = .init(view: view, type: .centerX)
        top = .init(view: view, type: .top)
        bottom = .init(view: view, type: .bottom)
        centerY = .init(view: view, type: .centerY)
        firstBaseline = .init(view: view, type: .firstBaseline)
        lastBaseline = .init(view: view, type: .lastBaseline)
        width = .init(view: view, type: .width)
        height = .init(view: view, type: .height)
    }
}


// MARK: - Anchor

extension ConstraintAnchor {
    
    public enum XAxisAnchor {
        case leading
        case trailing
        case centerX
    }
    
    public enum YAxisAnchor {
        case top
        case bottom
        case centerY
        case firstBaseline
        case lastBaseline
    }
    
    public enum DimensionAnchor {
        case width
        case height
    }
    
    public struct Anchor<AnchorType> {
        public let view: UIView
        public let type: AnchorType
        public var constraint: NSLayoutConstraint? { properties.constraint }
        fileprivate let properties = Properties()
        
        fileprivate class Properties {
            fileprivate var constraint: NSLayoutConstraint?
        }
        
        fileprivate func activate(_ constraint: NSLayoutConstraint) {
            view.translatesAutoresizingMaskIntoConstraints = false
            constraint.isActive = true
            properties.constraint = constraint
        }
        
        @discardableResult
        public func priority(_ priority: UILayoutPriority) -> Self {
            constraint?.priority = priority
            return self
        }
        
        @discardableResult
        public func store(in variable: inout NSLayoutConstraint?) -> Self {
            guard let constraint = constraint else { return self }
            variable = constraint
            return self
        }
        
        @discardableResult
        public func store(in array: inout [NSLayoutConstraint]) -> Self {
            guard let constraint = constraint else { return self }
            array.append(constraint)
            return self
        }
    }
}


// MARK: - XAxisAnchor

extension ConstraintAnchor.Anchor where AnchorType == ConstraintAnchor.XAxisAnchor {
    
    @discardableResult
    public func padding(_ padding: CGFloat) -> Self {
        guard let constraint = constraint else { return self }
        switch type {
        case .leading, .centerX: constraint.constant = padding
        case .trailing: constraint.constant = -padding
        }
        return self
    }
    
    @discardableResult
    public func equalTo(_ view: UIView) -> Self {
        switch type {
        case .leading: activate(self.view.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        case .trailing: activate(self.view.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        case .centerX: activate(self.view.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        }
        return self
    }
    
    @discardableResult
    public func equalTo(_ guide: UILayoutGuide) -> Self {
        switch type {
        case .leading: activate(view.leadingAnchor.constraint(equalTo: guide.leadingAnchor))
        case .trailing: activate(view.trailingAnchor.constraint(equalTo: guide.trailingAnchor))
        case .centerX: activate(view.centerXAnchor.constraint(equalTo: guide.centerXAnchor))
        }
        return self
    }
    
    @discardableResult
    public func equalTo(_ anchor: Self) -> Self {
        switch (type, anchor.type) {
        case (.leading, .leading): activate(view.leadingAnchor.constraint(equalTo: anchor.view.leadingAnchor))
        case (.leading, .trailing): activate(view.leadingAnchor.constraint(equalTo: anchor.view.trailingAnchor))
        case (.leading, .centerX): activate(view.leadingAnchor.constraint(equalTo: anchor.view.centerXAnchor))
            
        case (.trailing, .leading): activate(view.trailingAnchor.constraint(equalTo: anchor.view.leadingAnchor))
        case (.trailing, .trailing): activate(view.trailingAnchor.constraint(equalTo: anchor.view.trailingAnchor))
        case (.trailing, .centerX): activate(view.trailingAnchor.constraint(equalTo: anchor.view.centerXAnchor))
            
        case (.centerX, .leading): activate(view.centerXAnchor.constraint(equalTo: anchor.view.leadingAnchor))
        case (.centerX, .trailing): activate(view.centerXAnchor.constraint(equalTo: anchor.view.trailingAnchor))
        case (.centerX, .centerX): activate(view.centerXAnchor.constraint(equalTo: anchor.view.centerXAnchor))
        }
        return self
    }
    
    @discardableResult
    public func lessThanOrEqualTo(_ view: UIView) -> Self {
        switch type {
        case .leading: activate(self.view.leadingAnchor.constraint(lessThanOrEqualTo: view.leadingAnchor))
        case .trailing: activate(self.view.trailingAnchor.constraint(lessThanOrEqualTo: view.leadingAnchor))
        case .centerX: activate(self.view.centerXAnchor.constraint(lessThanOrEqualTo: view.leadingAnchor))
        }
        return self
    }
    
    @discardableResult
    public func lessThanOrEqualTo(_ guide: UILayoutGuide) -> Self {
        switch type {
        case .leading: activate(view.leadingAnchor.constraint(lessThanOrEqualTo: guide.leadingAnchor))
        case .trailing: activate(view.trailingAnchor.constraint(lessThanOrEqualTo: guide.leadingAnchor))
        case .centerX: activate(view.centerXAnchor.constraint(lessThanOrEqualTo: guide.leadingAnchor))
        }
        return self
    }
    
    @discardableResult
    public func lessThanOrEqualTo(_ anchor: Self) -> Self {
        switch (type, anchor.type) {
        case (.leading, .leading): activate(view.leadingAnchor.constraint(lessThanOrEqualTo: anchor.view.leadingAnchor))
        case (.leading, .trailing): activate(view.leadingAnchor.constraint(lessThanOrEqualTo: anchor.view.trailingAnchor))
        case (.leading, .centerX): activate(view.leadingAnchor.constraint(lessThanOrEqualTo: anchor.view.centerXAnchor))
            
        case (.trailing, .leading): activate(view.trailingAnchor.constraint(lessThanOrEqualTo: anchor.view.leadingAnchor))
        case (.trailing, .trailing): activate(view.trailingAnchor.constraint(lessThanOrEqualTo: anchor.view.trailingAnchor))
        case (.trailing, .centerX): activate(view.trailingAnchor.constraint(lessThanOrEqualTo: anchor.view.centerXAnchor))
            
        case (.centerX, .leading): activate(view.centerXAnchor.constraint(lessThanOrEqualTo: anchor.view.leadingAnchor))
        case (.centerX, .trailing): activate(view.centerXAnchor.constraint(lessThanOrEqualTo: anchor.view.trailingAnchor))
        case (.centerX, .centerX): activate(view.centerXAnchor.constraint(lessThanOrEqualTo: anchor.view.centerXAnchor))
        }
        return self
    }
    
    @discardableResult
    public func greaterThanOrEqualTo(_ view: UIView) -> Self {
        switch type {
        case .leading: activate(self.view.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor))
        case .trailing: activate(self.view.trailingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor))
        case .centerX: activate(self.view.centerXAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor))
        }
        return self
    }
    
    @discardableResult
    public func greaterThanOrEqualTo(_ guide: UILayoutGuide) -> Self {
        switch type {
        case .leading: activate(view.leadingAnchor.constraint(greaterThanOrEqualTo: guide.leadingAnchor))
        case .trailing: activate(view.trailingAnchor.constraint(greaterThanOrEqualTo: guide.leadingAnchor))
        case .centerX: activate(view.centerXAnchor.constraint(greaterThanOrEqualTo: guide.leadingAnchor))
        }
        return self
    }
    
    @discardableResult
    public func greaterThanOrEqualTo(_ anchor: Self) -> Self {
        switch (type, anchor.type) {
        case (.leading, .leading): activate(view.leadingAnchor.constraint(greaterThanOrEqualTo: anchor.view.leadingAnchor))
        case (.leading, .trailing): activate(view.leadingAnchor.constraint(greaterThanOrEqualTo: anchor.view.trailingAnchor))
        case (.leading, .centerX): activate(view.leadingAnchor.constraint(greaterThanOrEqualTo: anchor.view.centerXAnchor))
            
        case (.trailing, .leading): activate(view.trailingAnchor.constraint(greaterThanOrEqualTo: anchor.view.leadingAnchor))
        case (.trailing, .trailing): activate(view.trailingAnchor.constraint(greaterThanOrEqualTo: anchor.view.trailingAnchor))
        case (.trailing, .centerX): activate(view.trailingAnchor.constraint(greaterThanOrEqualTo: anchor.view.centerXAnchor))
            
        case (.centerX, .leading): activate(view.centerXAnchor.constraint(greaterThanOrEqualTo: anchor.view.leadingAnchor))
        case (.centerX, .trailing): activate(view.centerXAnchor.constraint(greaterThanOrEqualTo: anchor.view.trailingAnchor))
        case (.centerX, .centerX): activate(view.centerXAnchor.constraint(greaterThanOrEqualTo: anchor.view.centerXAnchor))
        }
        return self
    }
}


// MARK: - YAxisAnchor

extension ConstraintAnchor.Anchor where AnchorType == ConstraintAnchor.YAxisAnchor {
    
    @discardableResult
    public func padding(_ padding: CGFloat) -> Self {
        guard let constraint = constraint else { return self }
        switch type {
        case .top, .centerY, .firstBaseline: constraint.constant = padding
        case .bottom, .lastBaseline: constraint.constant = -padding
        }
        return self
    }
    
    @discardableResult
    public func equalTo(_ view: UIView) -> Self {
        switch type {
        case .top: activate(self.view.topAnchor.constraint(equalTo: view.topAnchor))
        case .bottom: activate(self.view.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        case .centerY: activate(self.view.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        case .firstBaseline: activate(self.view.firstBaselineAnchor.constraint(equalTo: view.firstBaselineAnchor))
        case .lastBaseline: activate(self.view.lastBaselineAnchor.constraint(equalTo: view.lastBaselineAnchor))
        }
        return self
    }
    
    @discardableResult
    public func equalTo(_ guide: UILayoutGuide) -> Self {
        switch type {
        case .top: activate(view.topAnchor.constraint(equalTo: guide.topAnchor))
        case .bottom: activate(view.bottomAnchor.constraint(equalTo: guide.bottomAnchor))
        case .centerY: activate(view.centerYAnchor.constraint(equalTo: guide.centerYAnchor))
        case .firstBaseline, .lastBaseline: print("⚠️ cannot constraint \(type) using func equalTo(_ guide: UILayoutGuide) ⚠️")
        }
        return self
    }
    
    @discardableResult
    public func equalTo(_ anchor: Self) -> Self {
        switch (type, anchor.type) {
        case (.top, .top): activate(view.topAnchor.constraint(equalTo: anchor.view.topAnchor))
        case (.top, .bottom): activate(view.topAnchor.constraint(equalTo: anchor.view.bottomAnchor))
        case (.top, .centerY): activate(view.topAnchor.constraint(equalTo: anchor.view.centerYAnchor))
        case (.top, .firstBaseline): activate(view.topAnchor.constraint(equalTo: anchor.view.firstBaselineAnchor))
        case (.top, .lastBaseline): activate(view.topAnchor.constraint(equalTo: anchor.view.lastBaselineAnchor))
        
        case (.bottom, .top): activate(view.bottomAnchor.constraint(equalTo: anchor.view.topAnchor))
        case (.bottom, .bottom): activate(view.bottomAnchor.constraint(equalTo: anchor.view.bottomAnchor))
        case (.bottom, .centerY): activate(view.bottomAnchor.constraint(equalTo: anchor.view.centerYAnchor))
        case (.bottom, .firstBaseline): activate(view.bottomAnchor.constraint(equalTo: anchor.view.firstBaselineAnchor))
        case (.bottom, .lastBaseline): activate(view.bottomAnchor.constraint(equalTo: anchor.view.lastBaselineAnchor))
        
        case (.centerY, .top): activate(view.centerYAnchor.constraint(equalTo: anchor.view.topAnchor))
        case (.centerY, .bottom): activate(view.centerYAnchor.constraint(equalTo: anchor.view.bottomAnchor))
        case (.centerY, .centerY): activate(view.centerYAnchor.constraint(equalTo: anchor.view.centerYAnchor))
        case (.centerY, .firstBaseline): activate(view.centerYAnchor.constraint(equalTo: anchor.view.firstBaselineAnchor))
        case (.centerY, .lastBaseline): activate(view.centerYAnchor.constraint(equalTo: anchor.view.lastBaselineAnchor))
        
        case (.firstBaseline, .top): activate(view.firstBaselineAnchor.constraint(equalTo: anchor.view.topAnchor))
        case (.firstBaseline, .bottom): activate(view.firstBaselineAnchor.constraint(equalTo: anchor.view.bottomAnchor))
        case (.firstBaseline, .centerY): activate(view.firstBaselineAnchor.constraint(equalTo: anchor.view.centerYAnchor))
        case (.firstBaseline, .firstBaseline): activate(view.firstBaselineAnchor.constraint(equalTo: anchor.view.firstBaselineAnchor))
        case (.firstBaseline, .lastBaseline): activate(view.firstBaselineAnchor.constraint(equalTo: anchor.view.lastBaselineAnchor))
        
        case (.lastBaseline, .top): activate(view.lastBaselineAnchor.constraint(equalTo: anchor.view.topAnchor))
        case (.lastBaseline, .bottom): activate(view.lastBaselineAnchor.constraint(equalTo: anchor.view.bottomAnchor))
        case (.lastBaseline, .centerY): activate(view.lastBaselineAnchor.constraint(equalTo: anchor.view.centerYAnchor))
        case (.lastBaseline, .firstBaseline): activate(view.lastBaselineAnchor.constraint(equalTo: anchor.view.firstBaselineAnchor))
        case (.lastBaseline, .lastBaseline): activate(view.lastBaselineAnchor.constraint(equalTo: anchor.view.lastBaselineAnchor))
        }
        return self
    }
    
    @discardableResult
    public func lessThanOrEqualTo(_ view: UIView) -> Self {
        switch type {
        case .top: activate(self.view.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor))
        case .bottom: activate(self.view.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor))
        case .centerY: activate(self.view.centerYAnchor.constraint(lessThanOrEqualTo: view.centerYAnchor))
        case .firstBaseline: activate(self.view.firstBaselineAnchor.constraint(lessThanOrEqualTo: view.firstBaselineAnchor))
        case .lastBaseline: activate(self.view.lastBaselineAnchor.constraint(lessThanOrEqualTo: view.lastBaselineAnchor))
        }
        return self
    }
    
    @discardableResult
    public func lessThanOrEqualTo(_ guide: UILayoutGuide) -> Self {
        switch type {
        case .top: activate(view.topAnchor.constraint(lessThanOrEqualTo: guide.topAnchor))
        case .bottom: activate(view.bottomAnchor.constraint(lessThanOrEqualTo: guide.bottomAnchor))
        case .centerY: activate(view.centerYAnchor.constraint(lessThanOrEqualTo: guide.centerYAnchor))
        case .firstBaseline, .lastBaseline: print("⚠️ cannot constraint \(type) using func lessThanOrEqualTo(_ guide: UILayoutGuide) ⚠️")
        }
        return self
    }
    
    @discardableResult
    public func lessThanOrEqualTo(_ anchor: Self) -> Self {
        switch (type, anchor.type) {
        case (.top, .top): activate(view.topAnchor.constraint(lessThanOrEqualTo: anchor.view.topAnchor))
        case (.top, .bottom): activate(view.topAnchor.constraint(lessThanOrEqualTo: anchor.view.bottomAnchor))
        case (.top, .centerY): activate(view.topAnchor.constraint(lessThanOrEqualTo: anchor.view.centerYAnchor))
        case (.top, .firstBaseline): activate(view.topAnchor.constraint(lessThanOrEqualTo: anchor.view.firstBaselineAnchor))
        case (.top, .lastBaseline): activate(view.topAnchor.constraint(lessThanOrEqualTo: anchor.view.lastBaselineAnchor))
        
        case (.bottom, .top): activate(view.bottomAnchor.constraint(lessThanOrEqualTo: anchor.view.topAnchor))
        case (.bottom, .bottom): activate(view.bottomAnchor.constraint(lessThanOrEqualTo: anchor.view.bottomAnchor))
        case (.bottom, .centerY): activate(view.bottomAnchor.constraint(lessThanOrEqualTo: anchor.view.centerYAnchor))
        case (.bottom, .firstBaseline): activate(view.bottomAnchor.constraint(lessThanOrEqualTo: anchor.view.firstBaselineAnchor))
        case (.bottom, .lastBaseline): activate(view.bottomAnchor.constraint(lessThanOrEqualTo: anchor.view.lastBaselineAnchor))
        
        case (.centerY, .top): activate(view.centerYAnchor.constraint(lessThanOrEqualTo: anchor.view.topAnchor))
        case (.centerY, .bottom): activate(view.centerYAnchor.constraint(lessThanOrEqualTo: anchor.view.bottomAnchor))
        case (.centerY, .centerY): activate(view.centerYAnchor.constraint(lessThanOrEqualTo: anchor.view.centerYAnchor))
        case (.centerY, .firstBaseline): activate(view.centerYAnchor.constraint(lessThanOrEqualTo: anchor.view.firstBaselineAnchor))
        case (.centerY, .lastBaseline): activate(view.centerYAnchor.constraint(lessThanOrEqualTo: anchor.view.lastBaselineAnchor))
        
        case (.firstBaseline, .top): activate(view.firstBaselineAnchor.constraint(lessThanOrEqualTo: anchor.view.topAnchor))
        case (.firstBaseline, .bottom): activate(view.firstBaselineAnchor.constraint(lessThanOrEqualTo: anchor.view.bottomAnchor))
        case (.firstBaseline, .centerY): activate(view.firstBaselineAnchor.constraint(lessThanOrEqualTo: anchor.view.centerYAnchor))
        case (.firstBaseline, .firstBaseline): activate(view.firstBaselineAnchor.constraint(lessThanOrEqualTo: anchor.view.firstBaselineAnchor))
        case (.firstBaseline, .lastBaseline): activate(view.firstBaselineAnchor.constraint(lessThanOrEqualTo: anchor.view.lastBaselineAnchor))
        
        case (.lastBaseline, .top): activate(view.lastBaselineAnchor.constraint(lessThanOrEqualTo: anchor.view.topAnchor))
        case (.lastBaseline, .bottom): activate(view.lastBaselineAnchor.constraint(lessThanOrEqualTo: anchor.view.bottomAnchor))
        case (.lastBaseline, .centerY): activate(view.lastBaselineAnchor.constraint(lessThanOrEqualTo: anchor.view.centerYAnchor))
        case (.lastBaseline, .firstBaseline): activate(view.lastBaselineAnchor.constraint(lessThanOrEqualTo: anchor.view.firstBaselineAnchor))
        case (.lastBaseline, .lastBaseline): activate(view.lastBaselineAnchor.constraint(lessThanOrEqualTo: anchor.view.lastBaselineAnchor))
        }
        return self
    }
    
    @discardableResult
    public func greaterThanOrEqualTo(_ view: UIView) -> Self {
        switch type {
        case .top: activate(self.view.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor))
        case .bottom: activate(self.view.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor))
        case .centerY: activate(self.view.centerYAnchor.constraint(greaterThanOrEqualTo: view.centerYAnchor))
        case .firstBaseline: activate(self.view.firstBaselineAnchor.constraint(greaterThanOrEqualTo: view.firstBaselineAnchor))
        case .lastBaseline: activate(self.view.lastBaselineAnchor.constraint(greaterThanOrEqualTo: view.lastBaselineAnchor))
        }
        return self
    }
    
    @discardableResult
    public func greaterThanOrEqualTo(_ guide: UILayoutGuide) -> Self {
        switch type {
        case .top: activate(view.topAnchor.constraint(greaterThanOrEqualTo: guide.topAnchor))
        case .bottom: activate(view.bottomAnchor.constraint(greaterThanOrEqualTo: guide.bottomAnchor))
        case .centerY: activate(view.centerYAnchor.constraint(greaterThanOrEqualTo: guide.centerYAnchor))
        case .firstBaseline, .lastBaseline: print("⚠️ cannot constraint \(type) using func lessThanOrEqualTo(_ guide: UILayoutGuide) ⚠️")
        }
        return self
    }
    
    @discardableResult
    public func greaterThanOrEqualTo(_ anchor: Self) -> Self {
        switch (type, anchor.type) {
        case (.top, .top): activate(view.topAnchor.constraint(greaterThanOrEqualTo: anchor.view.topAnchor))
        case (.top, .bottom): activate(view.topAnchor.constraint(greaterThanOrEqualTo: anchor.view.bottomAnchor))
        case (.top, .centerY): activate(view.topAnchor.constraint(greaterThanOrEqualTo: anchor.view.centerYAnchor))
        case (.top, .firstBaseline): activate(view.topAnchor.constraint(greaterThanOrEqualTo: anchor.view.firstBaselineAnchor))
        case (.top, .lastBaseline): activate(view.topAnchor.constraint(greaterThanOrEqualTo: anchor.view.lastBaselineAnchor))
        
        case (.bottom, .top): activate(view.bottomAnchor.constraint(greaterThanOrEqualTo: anchor.view.topAnchor))
        case (.bottom, .bottom): activate(view.bottomAnchor.constraint(greaterThanOrEqualTo: anchor.view.bottomAnchor))
        case (.bottom, .centerY): activate(view.bottomAnchor.constraint(greaterThanOrEqualTo: anchor.view.centerYAnchor))
        case (.bottom, .firstBaseline): activate(view.bottomAnchor.constraint(greaterThanOrEqualTo: anchor.view.firstBaselineAnchor))
        case (.bottom, .lastBaseline): activate(view.bottomAnchor.constraint(greaterThanOrEqualTo: anchor.view.lastBaselineAnchor))
        
        case (.centerY, .top): activate(view.centerYAnchor.constraint(greaterThanOrEqualTo: anchor.view.topAnchor))
        case (.centerY, .bottom): activate(view.centerYAnchor.constraint(greaterThanOrEqualTo: anchor.view.bottomAnchor))
        case (.centerY, .centerY): activate(view.centerYAnchor.constraint(greaterThanOrEqualTo: anchor.view.centerYAnchor))
        case (.centerY, .firstBaseline): activate(view.centerYAnchor.constraint(greaterThanOrEqualTo: anchor.view.firstBaselineAnchor))
        case (.centerY, .lastBaseline): activate(view.centerYAnchor.constraint(greaterThanOrEqualTo: anchor.view.lastBaselineAnchor))
        
        case (.firstBaseline, .top): activate(view.firstBaselineAnchor.constraint(greaterThanOrEqualTo: anchor.view.topAnchor))
        case (.firstBaseline, .bottom): activate(view.firstBaselineAnchor.constraint(greaterThanOrEqualTo: anchor.view.bottomAnchor))
        case (.firstBaseline, .centerY): activate(view.firstBaselineAnchor.constraint(greaterThanOrEqualTo: anchor.view.centerYAnchor))
        case (.firstBaseline, .firstBaseline): activate(view.firstBaselineAnchor.constraint(greaterThanOrEqualTo: anchor.view.firstBaselineAnchor))
        case (.firstBaseline, .lastBaseline): activate(view.firstBaselineAnchor.constraint(greaterThanOrEqualTo: anchor.view.lastBaselineAnchor))
        
        case (.lastBaseline, .top): activate(view.lastBaselineAnchor.constraint(greaterThanOrEqualTo: anchor.view.topAnchor))
        case (.lastBaseline, .bottom): activate(view.lastBaselineAnchor.constraint(greaterThanOrEqualTo: anchor.view.bottomAnchor))
        case (.lastBaseline, .centerY): activate(view.lastBaselineAnchor.constraint(greaterThanOrEqualTo: anchor.view.centerYAnchor))
        case (.lastBaseline, .firstBaseline): activate(view.lastBaselineAnchor.constraint(greaterThanOrEqualTo: anchor.view.firstBaselineAnchor))
        case (.lastBaseline, .lastBaseline): activate(view.lastBaselineAnchor.constraint(greaterThanOrEqualTo: anchor.view.lastBaselineAnchor))
        }
        return self
    }
}


// MARK: - DimensionAnchor

extension ConstraintAnchor.Anchor where AnchorType == ConstraintAnchor.DimensionAnchor {
    
    @discardableResult
    public func multiplier(_ multiplier: CGFloat) -> Self {
        guard let current = constraint else { return self }
        guard let view1 = current.firstItem, let view2 = current.secondItem else { return self }
        let update = NSLayoutConstraint(
            item: view1, attribute: current.firstAttribute, relatedBy: current.relation,
            toItem: view2, attribute: current.secondAttribute, multiplier: multiplier, constant: current.constant
        )
        current.isActive = false
        activate(update)
        return self
    }
    
    @discardableResult
    public func padding(_ padding: CGFloat) -> Self {
        guard let constraint = constraint else { return self }
        constraint.constant = -(padding * 2)
        return self
    }
    
    @discardableResult
    public func equalTo(_ constant: CGFloat) -> Self {
        switch type {
        case .width: activate(self.view.widthAnchor.constraint(equalToConstant: constant))
        case .height: activate(self.view.heightAnchor.constraint(equalToConstant: constant))
        }
        return self
    }
    
    @discardableResult
    public func equalTo(_ view: UIView) -> Self {
        switch type {
        case .width: activate(self.view.widthAnchor.constraint(equalTo: view.widthAnchor))
        case .height: activate(self.view.heightAnchor.constraint(equalTo: view.heightAnchor))
        }
        return self
    }
    
    @discardableResult
    public func equalTo(_ anchor: Self) -> Self {
        switch type {
        case .width: activate(view.widthAnchor.constraint(equalTo: anchor.view.widthAnchor))
        case .height: activate(view.heightAnchor.constraint(equalTo: anchor.view.heightAnchor))
        }
        return self
    }
    
    @discardableResult
    public func lessThanOrEqualTo(_ constant: CGFloat) -> Self {
        switch type {
        case .width: activate(view.widthAnchor.constraint(lessThanOrEqualToConstant: constant))
        case .height: activate(view.heightAnchor.constraint(lessThanOrEqualToConstant: constant))
        }
        return self
    }
    
    @discardableResult
    public func lessThanOrEqualTo(_ view: UIView) -> Self {
        switch type {
        case .width: activate(self.view.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor))
        case .height: activate(self.view.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor))
        }
        return self
    }
    
    @discardableResult
    public func lessThanOrEqualTo(_ anchor: Self) -> Self {
        switch type {
        case .width: activate(view.widthAnchor.constraint(lessThanOrEqualTo: anchor.view.widthAnchor))
        case .height: activate(view.heightAnchor.constraint(lessThanOrEqualTo: anchor.view.heightAnchor))
        }
        return self
    }
    
    @discardableResult
    public func greaterThanOrEqualTo(_ constant: CGFloat) -> Self {
        switch type {
        case .width: activate(view.widthAnchor.constraint(greaterThanOrEqualToConstant: constant))
        case .height: activate(view.heightAnchor.constraint(greaterThanOrEqualToConstant: constant))
        }
        return self
    }
    
    @discardableResult
    public func greaterThanOrEqualTo(_ view: UIView) -> Self {
        switch type {
        case .width: activate(self.view.widthAnchor.constraint(greaterThanOrEqualTo: view.widthAnchor))
        case .height: activate(self.view.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor))
        }
        return self
    }
    
    @discardableResult
    public func greaterThanOrEqualTo(_ anchor: Self) -> Self {
        switch type {
        case .width: activate(view.widthAnchor.constraint(greaterThanOrEqualTo: anchor.view.widthAnchor))
        case .height: activate(view.heightAnchor.constraint(greaterThanOrEqualTo: anchor.view.heightAnchor))
        }
        return self
    }
}


// MARK: - UIView Extension

extension UIView {
    
    public var anchor: ConstraintAnchor { .init(view: self) }
    
    public func constraint(anchor: (ConstraintAnchor) -> Void) {
        anchor(self.anchor)
    }
    
    @discardableResult
    public func constraint(fill view: UIView, padding: NSDirectionalEdgeInsets = .zero) -> (top: NSLayoutConstraint, leading: NSLayoutConstraint, bottom: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let top = topAnchor.constraint(equalTo: view.topAnchor, constant: padding.top)
        let leading = leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding.leading)
        let bottom = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding.bottom)
        let trailing = trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding.trailing)
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
        return (top, leading, bottom, trailing)
    }
    
    @discardableResult
    public func constraint(fill guide: UILayoutGuide, padding: NSDirectionalEdgeInsets = .zero) -> (top: NSLayoutConstraint, leading: NSLayoutConstraint, bottom: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let top = topAnchor.constraint(equalTo: guide.topAnchor, constant: padding.top)
        let leading = leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: padding.leading)
        let bottom = bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -padding.bottom)
        let trailing = trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -padding.trailing)
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
        return (top, leading, bottom, trailing)
    }
    
    @discardableResult
    public func constraint(center view: UIView) -> (centerX: NSLayoutConstraint, centerY: NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let centerX = centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let centerY = centerYAnchor.constraint(equalTo: view.centerYAnchor)
        NSLayoutConstraint.activate([centerX, centerY])
        return (centerX, centerY)
    }
    
    @discardableResult
    public func constraint(center guide: UILayoutGuide) -> (centerX: NSLayoutConstraint, centerY: NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let centerX = centerXAnchor.constraint(equalTo: guide.centerXAnchor)
        let centerY = centerYAnchor.constraint(equalTo: guide.centerYAnchor)
        NSLayoutConstraint.activate([centerX, centerY])
        return (centerX, centerY)
    }
}
