import UIKit


extension UIAction {
    
    public convenience init(handler: @escaping () -> Void) {
        self.init { action in
            handler()
        }
    }
}


extension UIControl {
    
    /// Add action to perform when an event is triggered.
    ///
    /// This is the same as calling `addAction(_:for:)`.
    ///
    /// - Parameters:
    ///   - event: The event to listen to.
    ///   - perform: The action to perform.
    public func onReceive(_ event: Event, perform: @escaping () -> Void) {
        addAction(UIAction(handler: perform), for: event)
    }
}
