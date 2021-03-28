import Foundation


/// A convenient object used to create closure that handle weak capture.
///
/// - Tag: Closure
///
public enum Closure {}


extension Closure {
    
    /// Create a closure that capture weak object.
    /// - Parameters:
    ///   - object: The object to capture.
    ///   - perform: The action to perform if the object is alive.
    /// - Returns: A closure.
    public static func weak<Object>(_ object: Object, perform: @escaping (Object) -> Void) -> () -> Void where Object: AnyObject {
        return { [weak object] in
            guard let object = object else { return }
            perform(object)
        }
    }
}


extension Closure {
    
    /// Create a closure that capture weak object.
    /// - Parameters:
    ///   - object: The object to capture.
    ///   - perform: The action to perform if the object is alive.
    /// - Returns: A closure.
    public static func weak<Object, Argument>(_ object: Object, perform: @escaping (Object, Argument) -> Void) -> (Argument) -> Void where Object: AnyObject {
        return { [weak object] argument in
            guard let object = object else { return }
            perform(object, argument)
        }
    }
    
    /// Create a closure that capture weak object.
    /// - Parameters:
    ///   - object: The object to capture.
    ///   - perform: The action to perform if the object is alive.
    /// - Returns: A closure.
    public static func weak<Object, Argument>(_ object: Object, argument: Argument.Type, perform: @escaping (Object, Argument) -> Void) -> (Argument) -> Void where Object: AnyObject {
        return { [weak object] argument in
            guard let object = object else { return }
            perform(object, argument)
        }
    }
}
