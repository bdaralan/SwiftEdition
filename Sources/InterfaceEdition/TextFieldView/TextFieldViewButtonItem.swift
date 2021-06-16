import SwiftUI


/// A button item listed under TextFieldView's text field.
public struct TextFieldViewButtonItem: TextFieldViewItem {
    
    public typealias SFSymbol = String
    
    public let id: String
    public var text: String
    public var icon: Image?
    public var foreground: Color?
    public var background: Color?
    public var action: () -> Void
    
    /// Create a button item.
    ///
    /// - Parameters:
    ///   - id: A unique ID for the button.
    ///   - text: The text for the button.
    ///   - icon: The image for the button
    ///   - action: The action to perform when the button is tapped.
    public init(id: String, text: String = "", icon: Image? = nil, action: @escaping () -> Void) {
        self.id = id
        self.text = text
        self.icon = icon
        self.action = action
    }
    
    /// Create a button item.
    ///
    /// - Parameters:
    ///   - id: A unique ID for the button.
    ///   - text: The text for the button.
    ///   - icon: The image for the button
    ///   - action: The action to perform when the button is tapped.
    public init(id: String, text: String = "", icon: SFSymbol, action: @escaping () -> Void) {
        self.id = id
        self.text = text
        self.icon = Image(systemName: icon)
        self.action = action
    }
    
    /// Return a new item with the specified foreground.
    public func foreground(_ color: Color) -> Self {
        var item = self
        item.foreground = color
        return item
    }
    
    /// Return a new item with the specified background.
    public func background(_ color: Color) -> Self {
        var item = self
        item.background = color
        return item
    }
}
