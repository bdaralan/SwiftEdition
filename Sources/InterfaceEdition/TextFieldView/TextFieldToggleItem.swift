import UIKit


public struct TextFieldToggleItem: TextFieldItem {
    
    public typealias StateValue<Active, Inactive> = (active: Active, inactive: Inactive)
    
    public let id: String
    
    public var type: TextFieldItemType { .toggle(self) }
    
    /// The state of the item.
    public var active: Bool
    
    /// A value indicates that the `active` property is updated automatically when the item is tapped.
    ///
    /// To manually toggle the `active` property, set this value to `false`. The default value is `true`.
    public var togglesActiveStateAutomatically = true
    
    /// The text of the item's current state.
    public var text: String {
        get { active ? texts.active : texts.inactive }
        set { active ? (texts.active = newValue) : (texts.inactive = newValue) }
    }
    
    /// The image of the item's current state.
    public var image: UIImage? {
        get { active ? images.active : images.inactive }
        set { active ? (images.active = newValue) : (images.inactive = newValue) }
    }
    
    /// The foreground of the item's current state.
    public var foreground: UIColor? {
        get { active ? foregrounds.active : foregrounds.inactive }
        set { active ? (foregrounds.active = newValue) : (foregrounds.inactive = newValue) }
    }
    
    /// The background of the item's current state.
    ///
    /// If need to match the default background appearance, use 0.1 opacity.
    public var background: UIColor? {
        get { active ? backgrounds.active : backgrounds.inactive }
        set { active ? (backgrounds.active = newValue) : (backgrounds.inactive = newValue) }
    }
    
    /// The active & inactive texts of the toggle.
    public var texts: StateValue<String, String> = ("", "")
    
    /// The active & inactive images of the toggle.
    public var images: StateValue<UIImage?, UIImage?> = (nil, nil)
    
    /// The active & inactive foregrounds of the toggle.
    public var foregrounds: StateValue<UIColor?, UIColor?> = (nil, nil)
    
    /// The active & inactive backgrounds of the toggle.
    ///
    /// If need to match the default background appearance, use 0.1 opacity.
    public var backgrounds: StateValue<UIColor?, UIColor?> = (nil, nil)
    
    let action: (TextFieldToggleItem) -> Void
    
    public init(
        id: String = UUID().uuidString,
        active: Bool,
        action: @escaping (TextFieldToggleItem) -> Void
    ) {
        self.id = id
        self.active = active
        self.action = action
    }
}
