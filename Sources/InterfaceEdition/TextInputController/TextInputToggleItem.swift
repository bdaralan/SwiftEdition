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
        get { active ? textState.active : textState.inactive }
        set { active ? (textState.active = newValue) : (textState.inactive = newValue) }
    }
    
    /// The image of the item's current state.
    public var image: UIImage? {
        get { active ? imageState.active : imageState.inactive }
        set { active ? (imageState.active = newValue) : (imageState.inactive = newValue) }
    }
    
    /// The foreground of the item's current state.
    public var foreground: UIColor? {
        get { active ? foregroundState.active : foregroundState.inactive }
        set { active ? (foregroundState.active = newValue) : (foregroundState.inactive = newValue) }
    }
    
    /// The background of the item's current state.
    ///
    /// If need to match the default background appearance, use 0.1 opacity.
    public var background: UIColor? {
        get { active ? backgroundState.active : backgroundState.inactive }
        set { active ? (backgroundState.active = newValue) : (backgroundState.inactive = newValue) }
    }
    
    /// The active & inactive texts of the toggle.
    public var textState: StateValue<String, String> = ("", "")
    
    /// The active & inactive images of the toggle.
    public var imageState: StateValue<UIImage?, UIImage?> = (nil, nil)
    
    /// The active & inactive foregrounds of the toggle.
    public var foregroundState: StateValue<UIColor?, UIColor?> = (nil, nil)
    
    /// The active & inactive backgrounds of the toggle.
    public var backgroundState: StateValue<UIColor?, UIColor?> = (nil, nil)
    
    let action: (TextInputToggleItem) -> Void
    
    public init(id: String = UUID().uuidString, active: Bool, action: @escaping (TextInputToggleItem) -> Void) {
        self.id = id
        self.active = active
        self.action = action
    }
}
