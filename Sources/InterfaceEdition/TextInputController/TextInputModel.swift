import UIKit


/// A state model used to managed `TextInputController`.
///
public final class TextInputModel: ObservableObject {
    
    @Published public var header = Header()
    
    @Published public var field = Field()
    
    @Published public var prompt = Prompt()
    
    @Published public var items = [TextInputItem]()
    
    @Published var action: Action?
    
    public var handler = Handler()
    
    public init() {}
    
    public func sendAction(_ action: Action) {
        self.action = action
    }
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
        
        public var initiallyActive = true
        
        public var keyboard: UIKeyboardType = .default
        
        public var returnKey: UIReturnKeyType = .done
        
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
    
    public enum Action {
        
        /// An action that will shake the text field horizontally.
        ///
        /// This can be used to indicate invalid input.
        case shakeTextField
    }
}
