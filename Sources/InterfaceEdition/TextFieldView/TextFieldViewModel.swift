import SwiftUI
import Combine


public struct TextFieldViewModel {
    
    public var header = Header()
    public var field = Field()
    public var prompt = Prompt()
    public var item = Item()
    
    let action: AnyPublisher<Action, Never>
    private let actionSubject = PassthroughSubject<Action, Never>()
    
    public init() {
        action = actionSubject.eraseToAnyPublisher()
    }
    
    public func sendAction(_ action: Action) {
        actionSubject.send(action)
    }
    
    public struct Header {
        public var title = "Title"
        public var cancel = "Cancel"
        public init() {}
    }

    public struct Field: Equatable {
        public var text = ""
        public var placeholder = ""
        public var isInitiallyActive = true
        public var keyboard: UIKeyboardType = .default
        public var returnKey: UIReturnKeyType = .done
        public var clearButtonMode: UITextField.ViewMode = .whileEditing
        public var isSecureEntry: Bool = false
        public var divider: Color?
        public init() {}
    }

    public struct Prompt {
        public var text = ""
        public var color: Color?
    }

    public struct Item {
        
    }

    public enum Action {
        case shakeTextField
    }
}
