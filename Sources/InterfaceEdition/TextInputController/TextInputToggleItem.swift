import UIKit


final class TextInputToggleItem: TextInputItem, Hashable {
    
    let id: String
    
    @Published var active: Bool
    
    @Published var text: String
    
    @Published var image: UIImage?
    
    @Published var foreground: String?
    
    @Published var background: String?
    
    let action: ((TextInputToggleItem) -> Void)?
    
    init(
        id: String = UUID().uuidString,
        active: Bool,
        text: String,
        image: UIImage?,
        foreground: String?,
        background: String?,
        action: ((TextInputToggleItem) -> Void)?
    ) {
        self.id = id
        self.active = active
        self.text = text
        self.image = image
        self.foreground = foreground
        self.background = background
        self.action = action
    }
    
    static func == (lhs: TextInputToggleItem, rhs: TextInputToggleItem) -> Bool {
        return lhs.id == rhs.id
            && lhs.active == rhs.active
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(active)
    }
}
