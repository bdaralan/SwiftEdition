import Foundation


/// A text input item listed in a horizontal scroll view.
///
/// - Note: Available items:
///
/// - `TextInputTagItem`
///
public protocol TextInputItem {
    
    /// A unique identifier for identifying the item.
    var id: String { get }
}
