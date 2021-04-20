import UIKit


/// - Tag: TextEditorModel
///
public final class TextEditorModel: ObservableObject {
    
    @Published public var header = Header()
    
    @Published public var field = Field()
    
    @Published public var counter = Counter()
    
    public var handler = Handler()
    
    public init() {}
}


extension TextEditorModel {
    
    public struct Header {
        public var title = "Title"
        public var cancel = "Cancel"
        public var submit = "Done"
    }
    
    public struct Field {
        public var text = ""
        public var placeholder = ""
        public var isInitiallyActive = true
        public var keyboardDismissMode: UIScrollView.KeyboardDismissMode = .interactive
    }
    
    public struct Counter {
        
        /// The max count.
        public var max: Int = 0
        
        /// A text to display as count progress.
        ///
        /// The block parameters are current count and max count.
        ///
        /// The default format is *count/max*. Set this value to `nil`, to hide the count.
        public var count: ((Int, Int) -> String)? = { "\($0)/\($1)" }
        
        /// The counter colors.
        public var colors: (min: UIColor, max: UIColor, exceeded: UIColor) = (.secondaryLabel, .secondaryLabel, .systemRed)
    }
    
    public struct Handler {
        public var onCancel: (() -> Void)?
        public var onCommit: (() -> Void)?
    }
}
