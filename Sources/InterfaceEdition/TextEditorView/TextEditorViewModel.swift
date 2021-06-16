import SwiftUI


public struct TextEditorViewModel {
    
    public var header = Header()
    
    public var field = Field()
    
    public var counter = Counter()
    
    public init() {}
}


extension TextEditorViewModel {
    
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
        
        /// The max count. The default is `0`.
        ///
        /// When set to `0` the counter is not displayed.
        public var max: Int = 0
        
        /// The counter colors.
        public var colors: (min: Color, max: Color, exceeded: Color) = (.secondary, .secondary, .red)
    }
}
