import UIKit


final class TextInputToggleItem: TextInputItem, Hashable {
    
    let id: String
    
    /// The state of the toggle.
    var active: Bool
    
    /// The text of the toggle.
    var text = Property<String?>(active: nil, inactive: nil)
    
    /// The image of the toggle.
    var image = Property<UIImage?>(active: nil, inactive: nil)
    
    /// The foreground of the toggle.
    var foreground = Property<UIColor?>(active: nil, inactive: nil)
    
    /// The background of the toggle.
    var background = Property<UIColor?>(active: nil, inactive: nil)
    
    let action: (TextInputToggleItem) -> Void
    
    struct Property<Value>: Equatable, Hashable where Value: Equatable & Hashable {
        var active: Value
        var inactive: Value
    }
    
    init(id: String = UUID().uuidString, active: Bool, action: @escaping (TextInputToggleItem) -> Void) {
        self.id = id
        self.active = active
        self.action = action
    }
    
    static func == (lhs: TextInputToggleItem, rhs: TextInputToggleItem) -> Bool {
        return lhs.id == rhs.id
            && lhs.active == rhs.active
            && lhs.text == rhs.text
            && lhs.image == rhs.image
            && lhs.foreground == rhs.foreground
            && lhs.background == rhs.background
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(active)
        hasher.combine(text)
        hasher.combine(image)
        hasher.combine(foreground)
        hasher.combine(background)
    }
}
