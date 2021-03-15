import UIKit


class TextEditorModel: ObservableObject {
    
    @Published var header = Header()
    @Published var field = Field()
    @Published var counter = Counter()
    var handler = Handler()
}


extension TextEditorModel {
    
    struct Header {
        var title = "Title"
        var cancel = "Cancel"
        var submit = "Done"
    }
    
    struct Field {
        var text = ""
        var placeholder = ""
        var isInitiallyActive = true
        var keyboardDismissMode: UIScrollView.KeyboardDismissMode = .interactive
    }
    
    struct Counter {
        
        /// The max count.
        var max: Int = 0
        
        /// A text to display as count progress.
        ///
        /// The block parameters are current count and max count.
        ///
        /// The default format is *count/max*. Set this value to `nil`, to hide the count.
        var count: ((Int, Int) -> String)? = { "\($0)/\($1)" }
        
        /// The counter colors.
        var colors: (min: UIColor, max: UIColor, exceeded: UIColor) = (.secondaryLabel, .secondaryLabel, .systemRed)
    }
    
    struct Handler {
        var onCancel: () -> Void = {}
        var onSubmit: () -> Void = {}
    }
}
