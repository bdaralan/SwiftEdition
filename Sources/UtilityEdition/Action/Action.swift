import Foundation


/// A convenient object used to create closure that handle weak capture.
public enum Action {}


extension Action {
    
    public static func weak<Object>(_ object: Object, perform: @escaping (Object) -> Void) -> () -> Void where Object: AnyObject {
        return { [weak object] in
            guard let object = object else { return }
            perform(object)
        }
    }
}


extension Action {
    
    public static func weak<Object, Argument>(_ object: Object, perform: @escaping (Object, Argument) -> Void) -> (Argument) -> Void where Object: AnyObject {
        return { [weak object] argument in
            guard let object = object else { return }
            perform(object, argument)
        }
    }
    
    public static func weak<Object, Argument>(_ object: Object, argument: Argument.Type, perform: @escaping (Object, Argument) -> Void) -> (Argument) -> Void where Object: AnyObject {
        return { [weak object] argument in
            guard let object = object else { return }
            perform(object, argument)
        }
    }
}
