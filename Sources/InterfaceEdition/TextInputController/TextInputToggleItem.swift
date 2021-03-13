import UIKit


public struct TextInputToggleItem: TextInputItem {
    
    public typealias StateValue<Value> = (active: Value, inactive: Value)
    
    public let id: String
    
    public var type: TextInputItemType { .toggle(self) }
    
    /// The state of the toggle.
    public var active: Bool
    
    /// The text of the toggle's current state.
    public var text: String { active ? texts.active : texts.inactive }
    
    /// The image of the toggle's current state.
    public var image: UIImage? { active ? images.active : images.inactive }
    
    /// The foreground of the toggle's current state.
    public var foreground: UIColor? { active ? foregrounds.active : foregrounds.inactive }
    
    /// The background of the toggle's current state.
    public var background: UIColor? { active ? backgrounds.active : backgrounds.inactive }
    
    /// The active & inactive texts of the toggle.
    public var texts: StateValue<String> = ("", "")
    
    /// The active & inactive images of the toggle.
    public var images: StateValue<UIImage?> = (nil, nil)
    
    /// The active & inactive foregrounds of the toggle.
    public var foregrounds: StateValue<UIColor?> = (nil, nil)
    
    /// The active & inactive backgrounds of the toggle.
    ///
    /// If need to match the *SwiftEdition's* appearance, use 0.1 opacity. :]
    public var backgrounds: StateValue<UIColor?> = (nil, nil)
    
    let action: (TextInputToggleItem) -> Void
    
    public init(id: String = UUID().uuidString, active: Bool, action: @escaping (TextInputToggleItem) -> Void) {
        self.id = id
        self.active = active
        self.action = action
    }
}
