import UIKit


extension UIAction {
    
    public convenience init(handler: @escaping () -> Void) {
        self.init { action in
            handler()
        }
    }
}


extension UIControl {
    
    public func onReceived(_ event: Event, perform: @escaping () -> Void) {
        addAction(UIAction(handler: perform), for: event)
    }
}
