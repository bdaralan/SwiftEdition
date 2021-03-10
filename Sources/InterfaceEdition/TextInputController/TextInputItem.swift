import UIKit


/// A text input item listed in a horizontal scroll view.
///
/// - Note: Available items:
///
/// - `TextInputTagItem`
///
public protocol TextInputItem {
    
    var id: String { get }
}


// MARK: - Tag Item

public struct TextInputTagItem: TextInputItem, Hashable {
    
    public let id: String
    
    public var text: String
    
    public var foreground: UIColor?
    
    public var background: UIColor?
    
    let action: UIAction?
    
    /// Create a tag item.
    ///
    /// If need to match the default background color, use a solid color with 0.1 opacity.
    ///
    /// - Parameters:
    ///   - id: An identifier. The default is a UUID.
    ///   - text: The name of the tag.
    ///   - foreground: The color of the text.
    ///   - background: The background color of the tag.
    ///   - action: An action to perform when tapped.
    public init(
        id: String = UUID().uuidString,
        text: String,
        foreground: UIColor? = nil,
        background: UIColor? = nil,
        action: (() -> Void)? = nil
    ) {
        self.id = id
        self.text = text
        self.foreground = foreground
        self.background = background
        self.action = action == nil ? nil : .init(handler: action!)
    }
}
