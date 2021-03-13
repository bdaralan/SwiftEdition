import UIKit


public struct TextInputToggleItem: TextInputItem {
    
    public typealias StateValue<Value> = (active: Value, inactive: Value)
    
    public let id: String
    
    public var type: TextInputItemType { .toggle(self) }
    
    /// The state of the toggle.
    public var active: Bool
    
    /// The text of the toggle's current state.
    public var text: String {
        get { active ? textState.active : textState.inactive }
        set { active ? (textState.active = newValue) : (textState.inactive = newValue) }
    }
    
    /// The image of the toggle's current state.
    public var image: UIImage? {
        get { active ? imageState.active : imageState.inactive }
        set { active ? (imageState.active = newValue) : (imageState.inactive = newValue) }
    }
    
    /// The foreground of the toggle's current state.
    public var foreground: UIColor? {
        get { active ? foregroundState.active : foregroundState.inactive }
        set { active ? (foregroundState.active = newValue) : (foregroundState.inactive = newValue) }
    }
    
    /// The background of the toggle's current state.
    public var background: UIColor? {
        get { active ? backgroundState.active : backgroundState.inactive }
        set { active ? (backgroundState.active = newValue) : (backgroundState.inactive = newValue) }
    }
    
    /// The active & inactive texts of the toggle.
    public var textState: StateValue<String> = ("", "")
    
    /// The active & inactive images of the toggle.
    public var imageState: StateValue<UIImage?> = (nil, nil)
    
    /// The active & inactive foregrounds of the toggle.
    public var foregroundState: StateValue<UIColor?> = (nil, nil)
    
    /// The active & inactive backgrounds of the toggle.
    ///
    /// If need to match the *SwiftEdition's* appearance, use 0.1 opacity. :]
    public var backgroundState: StateValue<UIColor?> = (nil, nil)
    
    let action: (TextInputToggleItem) -> Void
    
    public init(id: String = UUID().uuidString, active: Bool, action: @escaping (TextInputToggleItem) -> Void) {
        self.id = id
        self.active = active
        self.action = action
    }
}
