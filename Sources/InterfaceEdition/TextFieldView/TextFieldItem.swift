import Foundation


/// A text input item listed in a grid view.
///
/// - Note: See `TextFieldItemType` for available item.
///
public protocol TextFieldItem {
    
    /// A unique identifier for identifying the item.
    var id: String { get }
    
    /// The type of item.
    var type: TextFieldItemType { get }
}


/// A kind of text input item.
public enum TextFieldItemType {
    
    case tag(TextFieldTagItem)
    
    case toggle(TextFieldToggleItem)
}
