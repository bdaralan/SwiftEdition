import UIKit


// MARK: - Anchor

extension AutoLayoutAnchor {
    
    public struct Anchor<AnchorType>: AutoLayoutConstraintAnchor {
        
        /// The anchor's receiver view.
        public let view: UIView
        
        /// The type of anchor.
        public let type: AnchorType
        
        /// This value is `nil` if the anchor has not been set.
        public var constraint: NSLayoutConstraint? { properties.constraint }
        
        fileprivate let properties = Properties()
        
        fileprivate class Properties {
            fileprivate var constraint: NSLayoutConstraint?
        }
        
        fileprivate func activate(_ constraint: NSLayoutConstraint) {
            view.translatesAutoresizingMaskIntoConstraints = false
            properties.constraint?.isActive = false
            properties.constraint = constraint
            constraint.isActive = true
        }
        
        /// Set priority for the anchor.
        @discardableResult
        public func priority(_ priority: AutoLayoutAnchor.AnchorPriority) -> Self {
            properties.constraint?.priority = .init(priority.value)
            return self
        }
        
        /// Set priority for the anchor.
        @discardableResult
        public func priority(_ priority: Float) -> Self {
            properties.constraint?.priority = .init(priority)
            return self
        }
        
        /// Store the constraint in a variable.
        ///
        /// - Parameter variable: The variable to store the constraint object.
        @discardableResult
        public func storeIn(_ variable: inout NSLayoutConstraint?) -> Self {
            guard let constraint = properties.constraint else { return self }
            variable = constraint
            return self
        }
        
        /// Store constraint in array.
        ///
        /// - Parameter array: The array to store the constraint object.
        @discardableResult
        public func storeIn(_ array: inout [NSLayoutConstraint]) -> Self {
            guard let constraint = properties.constraint else { return self }
            array.append(constraint)
            return self
        }
        
        /// Store the anchor in a variable.
        ///
        /// - Parameter variable: The variable to store the anchor.
        @discardableResult
        public func storeIn(_ variable: inout AutoLayoutConstraintAnchor?) -> Self {
            variable = self
            return self
        }
        
        /// Store anchor in array.
        ///
        /// - Parameter array: The array to store the anchor.
        @discardableResult
        public func storeIn(_ array: inout [AutoLayoutConstraintAnchor]) -> Self {
            array.append(self)
            return self
        }
    }
}


// MARK: - Anchor Type

extension AutoLayoutAnchor {
    
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
    
    public enum XYAxisEdgeAnchor {
        case top
        case bottom
        case leading
        case trailing
    }
    
    public struct AnchorPriority {
        
        public let value: Float
        
        public init(_ value: Float) {
            self.value = value
        }
        
        init(_ priority: UILayoutPriority) {
            value = priority.rawValue
        }
        
        static public func +(lhs: Self, rhs: Float) -> Self {
            .init(lhs.value + rhs)
        }
        
        static public func -(lhs: Self, rhs: Float) -> Self {
            .init(lhs.value - rhs)
        }
        
        static public let required = AnchorPriority(.required)
        
        static public let high = AnchorPriority(.defaultHigh)
        
        static public let dragCanResizeScene = AnchorPriority(.dragThatCanResizeScene)
        
        static public let sceneSizeStayPut = AnchorPriority(.sceneSizeStayPut)
        
        static public let dragCannotResizeScene = AnchorPriority(.dragThatCannotResizeScene)
        
        static public let low = AnchorPriority(.defaultLow)
        
        static public let fittingSizeLevel = AnchorPriority(.fittingSizeLevel)
    }
}


// MARK: - XAxisAnchor

extension AutoLayoutAnchor.Anchor where AnchorType == AutoLayoutAnchor.XAxisAnchor {
    
    /// Add padding to the anchor.
    ///
    /// Chaining will not stack up.
    @discardableResult
    public func padding(_ padding: CGFloat) -> Self {
        guard let constraint = properties.constraint else { return self }
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
        case .trailing: activate(self.view.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor))
        case .centerX: activate(self.view.centerXAnchor.constraint(lessThanOrEqualTo: view.centerXAnchor))
        }
        return self
    }
    
    @discardableResult
    public func lessThanOrEqualTo(_ guide: UILayoutGuide) -> Self {
        switch type {
        case .leading: activate(view.leadingAnchor.constraint(lessThanOrEqualTo: guide.leadingAnchor))
        case .trailing: activate(view.trailingAnchor.constraint(lessThanOrEqualTo: guide.trailingAnchor))
        case .centerX: activate(view.centerXAnchor.constraint(lessThanOrEqualTo: guide.centerXAnchor))
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
        case .trailing: activate(self.view.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor))
        case .centerX: activate(self.view.centerXAnchor.constraint(greaterThanOrEqualTo: view.centerXAnchor))
        }
        return self
    }
    
    @discardableResult
    public func greaterThanOrEqualTo(_ guide: UILayoutGuide) -> Self {
        switch type {
        case .leading: activate(view.leadingAnchor.constraint(greaterThanOrEqualTo: guide.leadingAnchor))
        case .trailing: activate(view.trailingAnchor.constraint(greaterThanOrEqualTo: guide.trailingAnchor))
        case .centerX: activate(view.centerXAnchor.constraint(greaterThanOrEqualTo: guide.centerXAnchor))
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

extension AutoLayoutAnchor.Anchor where AnchorType == AutoLayoutAnchor.YAxisAnchor {
    
    /// Add padding to the anchor.
    ///
    /// Chaining will not stack up.
    @discardableResult
    public func padding(_ padding: CGFloat) -> Self {
        guard let constraint = properties.constraint else { return self }
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
        case .firstBaseline, .lastBaseline: print("⚠️ cannot anchor \(type) using func equalTo(_ guide: UILayoutGuide) ⚠️")
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
        case .firstBaseline, .lastBaseline: print("⚠️ cannot anchor \(type) using func lessThanOrEqualTo(_ guide: UILayoutGuide) ⚠️")
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
        case .firstBaseline, .lastBaseline: print("⚠️ cannot anchor \(type) using func lessThanOrEqualTo(_ guide: UILayoutGuide) ⚠️")
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

extension AutoLayoutAnchor.Anchor where AnchorType == AutoLayoutAnchor.DimensionAnchor {
    
    @discardableResult
    public func multiplier(_ multiplier: CGFloat) -> Self {
        guard let constraint = properties.constraint else { return self }
        guard let view1 = constraint.firstItem, let view2 = constraint.secondItem else { return self }
        let updateConstraint = NSLayoutConstraint(
            item: view1, attribute: constraint.firstAttribute, relatedBy: constraint.relation,
            toItem: view2, attribute: constraint.secondAttribute, multiplier: multiplier, constant: constraint.constant
        )
        activate(updateConstraint)
        return self
    }
    
    /// Add a constant to the current value.
    ///
    /// Chaining will stack up.
    @discardableResult
    public func add(_ constant: CGFloat) -> Self {
        guard let constraint = properties.constraint else { return self }
        constraint.constant += constant
        return self
    }
    
    /// Subtract a constant from the current value.
    ///
    /// Chaining will stack up.
    @discardableResult
    public func subtract(_ constant: CGFloat) -> Self {
        guard let constraint = properties.constraint else { return self }
        constraint.constant -= constant
        return self
    }
    
    @discardableResult
    public func equalTo(_ constant: CGFloat) -> Self {
        switch type {
        case .width: activate(view.widthAnchor.constraint(equalToConstant: constant))
        case .height: activate(view.heightAnchor.constraint(equalToConstant: constant))
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
    public func equalTo(_ guide: UILayoutGuide) -> Self {
        switch type {
        case .width: activate(view.widthAnchor.constraint(equalTo: guide.widthAnchor))
        case .height: activate(view.heightAnchor.constraint(equalTo: guide.heightAnchor))
        }
        return self
    }
    
    @discardableResult
    public func equalTo(_ anchor: Self) -> Self {
        switch (type, anchor.type) {
        case (.width, .width): activate(view.widthAnchor.constraint(equalTo: anchor.view.widthAnchor))
        case (.width, .height): activate(view.widthAnchor.constraint(equalTo: anchor.view.heightAnchor))
            
        case (.height, .width): activate(view.heightAnchor.constraint(equalTo: anchor.view.widthAnchor))
        case (.height, .height): activate(view.heightAnchor.constraint(equalTo: anchor.view.heightAnchor))
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
    public func lessThanOrEqualTo(_ guide: UILayoutGuide) -> Self {
        switch type {
        case .width: activate(view.widthAnchor.constraint(lessThanOrEqualTo: guide.widthAnchor))
        case .height: activate(view.heightAnchor.constraint(lessThanOrEqualTo: guide.heightAnchor))
        }
        return self
    }
    
    @discardableResult
    public func lessThanOrEqualTo(_ anchor: Self) -> Self {
        switch (type, anchor.type) {
        case (.width, .width): activate(view.widthAnchor.constraint(lessThanOrEqualTo: anchor.view.widthAnchor))
        case (.width, .height): activate(view.widthAnchor.constraint(lessThanOrEqualTo: anchor.view.heightAnchor))
            
        case (.height, .width): activate(view.heightAnchor.constraint(lessThanOrEqualTo: anchor.view.widthAnchor))
        case (.height, .height): activate(view.heightAnchor.constraint(lessThanOrEqualTo: anchor.view.heightAnchor))
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
    public func greaterThanOrEqualTo(_ guide: UILayoutGuide) -> Self {
        switch type {
        case .width: activate(view.widthAnchor.constraint(greaterThanOrEqualTo: guide.widthAnchor))
        case .height: activate(view.heightAnchor.constraint(greaterThanOrEqualTo: guide.heightAnchor))
        }
        return self
    }
    
    @discardableResult
    public func greaterThanOrEqualTo(_ anchor: Self) -> Self {
        switch (type, anchor.type) {
        case (.width, .width): activate(view.widthAnchor.constraint(greaterThanOrEqualTo: anchor.view.widthAnchor))
        case (.width, .height): activate(view.widthAnchor.constraint(greaterThanOrEqualTo: anchor.view.heightAnchor))
            
        case (.height, .width): activate(view.heightAnchor.constraint(greaterThanOrEqualTo: anchor.view.widthAnchor))
        case (.height, .height): activate(view.heightAnchor.constraint(greaterThanOrEqualTo: anchor.view.heightAnchor))
        }
        return self
    }
}


// MARK: - Protocol & Extension

/// - Tag: AutoLayoutConstraintAnchor
///
public protocol AutoLayoutConstraintAnchor {
    
    var constraint: NSLayoutConstraint? { get }
}


extension Array where Element == AutoLayoutConstraintAnchor {
    
    /// Activate the constraints.
    public func activate() {
        NSLayoutConstraint.activate(compactMap(\.constraint))
    }
    
    /// Deactivate the constraints.
    public func deactivate() {
        NSLayoutConstraint.deactivate(compactMap(\.constraint))
    }
}


// MARK: - Typealias

/// - Tag: AutoLayoutXAxisAnchor
///
public typealias AutoLayoutXAxisAnchor = AutoLayoutAnchor.Anchor<AutoLayoutAnchor.XAxisAnchor>

/// - Tag: AutoLayoutYAxisAnchor
///
public typealias AutoLayoutYAxisAnchor = AutoLayoutAnchor.Anchor<AutoLayoutAnchor.YAxisAnchor>

/// - Tag: AutoLayoutDimensionAnchor
///
public typealias AutoLayoutDimensionAnchor = AutoLayoutAnchor.Anchor<AutoLayoutAnchor.DimensionAnchor>
