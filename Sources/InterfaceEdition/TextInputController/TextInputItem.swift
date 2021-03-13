import Foundation


/// A text input item listed in a horizontal scroll view.
///
/// - Note: See `TextInputItemType` for available item.
///
public protocol TextInputItem {
    
    /// A unique identifier for identifying the item.
    var id: String { get }
    
    /// The type of item.
    var type: TextInputItemType { get }
}


/// A kind of text input item.
public enum TextInputItemType {
    
    case tag(TextInputTagItem)
    
    case toggle(TextInputToggleItem)
}
