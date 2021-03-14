import UIKit


public struct TextInputToggleItem: TextInputItem {
    
    public typealias StateValue<Active, Inactive> = (active: Active, inactive: Inactive)
    
    public let id: String
    
    public var type: TextInputItemType { .toggle(self) }
    
    /// The state of the item.
    public var active: Bool
    
    /// A value indicates that the `active` property is updated automatically.
    ///
    /// To manually update the `active` property, set this value to `false`. The default value is `true`.
    public var updatesActiveStateAutomatically = true
    
    /// The text of the item's current state.
    public var text: String {
        get { active ? textValue.active : textValue.inactive }
        set { active ? (textValue.active = newValue) : (textValue.inactive = newValue) }
    }
    
    /// The image of the item's current state.
    public var image: UIImage? {
        get { active ? imageValue.active : imageValue.inactive }
        set { active ? (imageValue.active = newValue) : (imageValue.inactive = newValue) }
    }
    
    /// The foreground of the item's current state.
    public var foreground: UIColor? {
        get { active ? foregroundValue.active : foregroundValue.inactive }
        set { active ? (foregroundValue.active = newValue) : (foregroundValue.inactive = newValue) }
    }
    
    /// The background of the item's current state.
    ///
    /// If need to match the default background appearance, use 0.1 opacity.
    public var background: UIColor? {
        get { active ? backgroundValue.active : backgroundValue.inactive }
        set { active ? (backgroundValue.active = newValue) : (backgroundValue.inactive = newValue) }
    }
    
    /// The active & inactive texts of the toggle.
    public var textValue: StateValue<String, String> = ("", "")
    
    /// The active & inactive images of the toggle.
    public var imageValue: StateValue<UIImage?, UIImage?> = (nil, nil)
    
    /// The active & inactive foregrounds of the toggle.
    public var foregroundValue: StateValue<UIColor?, UIColor?> = (nil, nil)
    
    /// The active & inactive backgrounds of the toggle.
    public var backgroundValue: StateValue<UIColor?, UIColor?> = (nil, nil)
    
    let action: (TextInputToggleItem) -> Void
    
    public init(id: String = UUID().uuidString, active: Bool, action: @escaping (TextInputToggleItem) -> Void) {
        self.id = id
        self.active = active
        self.action = action
    }
}
