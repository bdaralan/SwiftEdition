import UIKit


/// A state model used to managed `TextInputViewController`.
///
public final class TextInputModel: ObservableObject {
    
    @Published public var header = Header()
    
    @Published public var field = Field()
    
    @Published public var prompt = Prompt()
    
    @Published public var items = [TextInputItem]()
    
    public var actions = Actions()
    
    public init() {}
}


extension TextInputModel {
    
    public struct Header {
        
        public var title = "Title"
        
        public var cancel = "Cancel"
        
        public init() {}
    }
    
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
    
    public struct Prompt {
        
        public var text = ""
        
        public var color: UIColor?
        
        public init() {}
    }
    
    public struct Actions {
        
        /// An action for cancel button.
        public var onCancel: (() -> Void)?
        
        /// An action for keyboard return key.
        public var onCommit: (() -> Void)?
        
        public init() {}
    }
}


/// A text input item listed in a horizontal scroll view.
///
/// - Note: Available items:
///
/// - `TextInputModel.TagItem`
///
public protocol TextInputItem {
    
    var id: String { get }
}


extension TextInputModel {
    
    public struct TagItem: TextInputItem, Hashable {
        
        public let id: String
        
        public var text: String
        
        public var foreground: UIColor?
        
        public var background: UIColor?
        
        var action: UIAction?
        
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
        
        func performAction() {
            guard let action = action else { return }
            let control = UIControl(frame: .zero, primaryAction: action)
            control.sendAction(action)
        }
    }
}
