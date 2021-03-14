import UIKit
import Combine


/// A state model used to managed `TextInputController`.
///
public final class TextInputModel: ObservableObject {
    
    @Published public var header = Header()
    
    @Published public var field = Field()
    
    @Published public var prompt = Prompt()
    
    @Published public var item = Item()
    
    public let action = Action()
    
    public var handler = Handler()
    
    public init() {}
}


// MARK: - Header

extension TextInputModel {
    
    public struct Header {
        
        public var title = "Title"
        
        public var cancel = "Cancel"
        
        public init() {}
    }
}


// MARK: - Field

extension TextInputModel {
    
    public struct Field {
        
        public var text = ""
        
        public var placeholder = ""
        
        /// A value indicates that the text field should be the first responder when appear.
        public var isInitiallyActive = true
        
        public var keyboard: UIKeyboardType = .default
        
        public var returnKey: UIReturnKeyType = .done
        
        public var isSecureEntry: Bool = false
        
        /// Use this to format text when text changed.
        public var formatter: ((String) -> String)?
        
        public var divider: UIColor?
        
        public init() {}
    }
}


// MARK: - Prompt

extension TextInputModel {
    
    public struct Prompt {
        
        public var text = ""
        
        public var color: UIColor?
        
        public init() {}
    }
}


extension TextInputModel {
    
    public struct Item {
        
        public var items: [TextInputItem] = []
        
        public var layout: Layout = .horizontal
        
        public enum Layout {
            case horizontal
        }
        
        public mutating func update(_ item: TextInputItem) {
            guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
            items[index] = item
        }
        
        public mutating func replace(itemID: String, with item: TextInputItem) {
            guard let index = items.firstIndex(where: { $0.id == itemID }) else { return }
            items[index] = item
        }
        
        public mutating func delete(itemID: String) {
            guard let index = items.firstIndex(where: { $0.id == itemID }) else { return }
            items.remove(at: index)
        }
    }
}


// MARK: - Handler

extension TextInputModel {
    
    public struct Handler {
        
        /// An action for cancel button.
        public var onCancel: (() -> Void)?
        
        /// An action for keyboard return key.
        public var onCommit: (() -> Void)?
        
        public init() {}
    }
}


// MARK: - Action

extension TextInputModel {
    
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
