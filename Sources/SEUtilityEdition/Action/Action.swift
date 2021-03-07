import Foundation


/// A convenient object used to create closure that handle weak capture.
public enum Action<Object, Argument> {}


public extension Action where Object: AnyObject, Argument == Never {
    
    static func weak(_ object: Object, perform: @escaping (Object) -> Void) -> () -> Void {
        let action = { [weak object] in
            guard let object = object else { return }
            perform(object)
        }
        return action
    }
}


public extension Action where Object: AnyObject {
    
    static func weak(_ object: Object, perform: @escaping (Object, Argument) -> Void) -> (Argument) -> Void {
        return { [weak object] argument in
            guard let object = object else { return }
            perform(object, argument)
        }
    }
    
    static func weak(_ object: Object, argument: Argument.Type, perform: @escaping (Object, Argument) -> Void) -> (Argument) -> Void {
        return { [weak object] argument in
            guard let object = object else { return }
            perform(object, argument)
        }
    }
}
