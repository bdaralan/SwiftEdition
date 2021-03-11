import UIKit


public final class TextInputTagItem: TextInputItem, Hashable {
    
    public let id: String
    
    @Published public var text: String
    
    @Published public var image: UIImage?
    
    @Published public var foreground: UIColor?
    
    @Published public var background: UIColor?
    
    let action: ((TextInputTagItem) -> Void)?
    
    /// Create a tag item.
    ///
    /// If need to match the default background color, use a solid color with 0.1 opacity.
    ///
    /// - Parameters:
    ///   - id: An identifier. The default is a UUID.
    ///   - text: The name of the tag.
    ///   - image: The leading image of the tag.
    ///   - foreground: The color of the text.
    ///   - background: The background color of the tag.
    ///   - action: An action to perform when tapped. The provided value is the item's index.
    public init(
        id: String = UUID().uuidString,
        text: String,
        image: UIImage? = nil,
        foreground: UIColor? = nil,
        background: UIColor? = nil,
        action: ((TextInputTagItem) -> Void)? = nil
    ) {
        self.id = id
        self.text = text
        self.image = image
        self.foreground = foreground
        self.background = background
        self.action = action
    }
    
    public static func == (lhs: TextInputTagItem, rhs: TextInputTagItem) -> Bool {
        return lhs.id == rhs.id
            && lhs.text == rhs.text
            && lhs.image == rhs.image
            && lhs.foreground == rhs.foreground
            && lhs.background == rhs.background
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(text)
        hasher.combine(image)
        hasher.combine(foreground)
        hasher.combine(background)
    }
}
