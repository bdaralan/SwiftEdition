import UIKit


public extension UIAction {
    
    convenience init(handler: @escaping () -> Void) {
        self.init { action in
            handler()
        }
    }
}
