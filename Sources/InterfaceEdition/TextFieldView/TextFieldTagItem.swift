import SwiftUI


public struct TextFieldTagItem: TextFieldItem {
    
    public let id: String
    
    public var type: TextFieldItemType { .tag(self) }
    
    /// The name of the tag.
    public var text: String
    
    /// The image of the tag.
    public var image: UIImage?
    
    /// The foreground color of the tag.
    public var foreground: UIColor?
    
    /// The background color of the tag.
    ///
    /// If need to match the default background appearance, use 0.1 opacity.
    public var background: UIColor?
    
    let action: ((TextFieldTagItem) -> Void)?
    
    /// Create a tag item.
    ///
    /// - Parameters:
    ///   - id: An identifier. The default is a UUID.
    ///   - text: The name of the tag.
    ///   - image: The leading image of the tag.
    ///   - foreground: The foreground color of the tag.
    ///   - background: The background color of the tag.
    ///   - action: An action to perform when tapped.
    public init(
        id: String = UUID().uuidString,
        text: String,
        image: UIImage? = nil,
        foreground: UIColor? = nil,
        background: UIColor? = nil,
        action: ((TextFieldTagItem) -> Void)? = nil
    ) {
        self.id = id
        self.text = text
        self.image = image
        self.foreground = foreground
        self.background = background
        self.action = action
    }
}
