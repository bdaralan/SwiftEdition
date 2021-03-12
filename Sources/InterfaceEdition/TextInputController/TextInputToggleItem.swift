import UIKit


public final class TextInputToggleItem: TextInputItem, Hashable {
    
    public let id: String
    
    /// The state of the toggle.
    public var active: Bool
    
    /// The text of the toggle.
    public var text = Property<String>(active: "", inactive: "")
    
    /// The image of the toggle.
    public var image = Property<UIImage?>(active: nil, inactive: nil)
    
    /// The foreground of the toggle.
    public var foreground = Property<UIColor?>(active: nil, inactive: nil)
    
    /// The background of the toggle.
    ///
    /// If need to match the default background style, use 0.1 opacity.
    public var background = Property<UIColor?>(active: nil, inactive: nil)
    
    let action: (TextInputToggleItem) -> Void
    
    public struct Property<Value>: Equatable, Hashable where Value: Equatable & Hashable {
        public var active: Value
        public var inactive: Value
    }
    
    public init(id: String = UUID().uuidString, active: Bool, action: @escaping (TextInputToggleItem) -> Void) {
        self.id = id
        self.active = active
        self.action = action
    }
    
    public static func == (lhs: TextInputToggleItem, rhs: TextInputToggleItem) -> Bool {
        return lhs.id == rhs.id
            && lhs.active == rhs.active
            && lhs.text == rhs.text
            && lhs.image == rhs.image
            && lhs.foreground == rhs.foreground
            && lhs.background == rhs.background
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(active)
        hasher.combine(text)
        hasher.combine(image)
        hasher.combine(foreground)
        hasher.combine(background)
    }
}
