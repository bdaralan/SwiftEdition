import UIKit


extension UIAction {
    
    public convenience init(handler: @escaping () -> Void) {
        self.init { action in
            handler()
        }
    }
}


extension UIControl {
    
    public func addAction(_ action: @escaping () -> Void, for event: Event) {
        addAction(UIAction(handler: action), for: event)
    }
}
