import UIKit
import Combine


/// A state model used to managed `TextFieldView`.
///
public final class TextFieldModel: ObservableObject {
    
    @Published public var header = Header()
    
    @Published public var field = Field()
    
    @Published public var prompt = Prompt()
    
    @Published public var item = Item()
    
    public let action = Action()
    
    public var handler = Handler()
    
    public init() {}
}


// MARK: - Header

extension TextFieldModel {
    
    public struct Header {
        
        public var title = "Title"
        
        public var cancel = "Cancel"
        
        public init() {}
    }
}


// MARK: - Field

extension TextFieldModel {
    
    /// Hello
    public struct Field {
        
        public var text = ""
        
        public var placeholder = ""
        
        /// A value indicates that the text field should be the first responder when appear.
        public var isInitiallyActive = true
        
        public var keyboard: UIKeyboardType = .default
        
        public var returnKey: UIReturnKeyType = .done
        
        public var clearButtonMode: UITextField.ViewMode = .whileEditing
        
        public var isSecureEntry: Bool = false
        
        public var divider: UIColor?
        
        public init() {}
    }
}


// MARK: - Prompt

extension TextFieldModel {
    
    public struct Prompt {
        
        public var text = ""
        
        public var color: UIColor?
        
        public init() {}
    }
}


extension TextFieldModel {
    
    public struct Item {
        
        public var items: [TextFieldItem] = []
        
        public var layout: Layout = .default
        
        public enum Layout {
            case `default`
        }
        
        /// Update the item with same ID with the new item.
        ///
        /// - Parameter item: The new item.
        public mutating func update(_ item: TextFieldItem) {
            guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
            items[index] = item
        }
        
        /// Replace the item with the specified ID with the new item.
        ///
        /// - Parameters:
        ///   - itemID: The ID of the item to be replaced.
        ///   - item: The replacement item.
        public mutating func replace(itemID: String, with item: TextFieldItem) {
            guard let index = items.firstIndex(where: { $0.id == itemID }) else { return }
            items[index] = item
        }
        
        /// Delete the item with the specified ID.
        ///
        /// - Parameter itemID: The ID of the item to be deleted.
        public mutating func delete(itemID: String) {
            guard let index = items.firstIndex(where: { $0.id == itemID }) else { return }
            items.remove(at: index)
        }
    }
}


// MARK: - Handler

extension TextFieldModel {
    
    public struct Handler {
        
        /// An action for cancel button.
        public var onCancel: (() -> Void)?
        
        /// An action for keyboard return key.
        public var onCommit: (() -> Void)?
        
        /// Use this to format text when text changed.
        public var onTextChange: ((String) -> String)?
        
        public init() {}
    }
}


// MARK: - Action

extension TextFieldModel {
    
    public struct Action {
        
        let publisher: AnyPublisher<ActionType, Never>
        
        private let subject = PassthroughSubject<ActionType, Never>()
        
        public init() {
            publisher = subject.eraseToAnyPublisher()
        }
        
        public func perform(_ actionType: ActionType) {
            subject.send(actionType)
        }
        
        public enum ActionType {
            
            /// An action that will shake the text field horizontally.
            ///
            /// This can be used to indicate invalid input.
            case shakeTextField
        }
    }
}
