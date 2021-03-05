import UIKit


/// A convenient object used to create closure that handle weak capture.
public enum GuardAction<Object, Argument> {}


public extension GuardAction where Object: AnyObject, Argument == Never {
    
    static func weak(_ object: Object, perform: @escaping (Object) -> Void) -> () -> Void {
        let action = { [weak object] in
            guard let object = object else { return }
            perform(object)
        }
        return action
    }
}


public extension GuardAction where Object: AnyObject {
    
    static func weak(_ object: Object, perform: @escaping (Object, Argument) -> Void) -> (Argument) -> Void {
        let action = { [weak object] (argument: Argument) in
            guard let object = object else { return }
            perform(object, argument)
        }
        return action
    }
    
    static func weak(_ object: Object, argument: Argument.Type, perform: @escaping (Object, Argument) -> Void) -> (Argument) -> Void {
        let action = { [weak object] (argument: Argument) in
            guard let object = object else { return }
            perform(object, argument)
        }
        return action
    }
}
