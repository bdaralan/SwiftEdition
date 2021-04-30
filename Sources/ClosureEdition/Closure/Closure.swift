import Foundation


/// Create a closure that capture weak object.
///
/// - Parameters:
///   - object: The object to capture.
///   - perform: The action to perform if the object is alive.
/// - Returns: A closure.
public func weak<Object>(_ object: Object, perform: @escaping (Object) -> Void) -> () -> Void where Object: AnyObject {
    return { [weak object] in
        guard let object = object else { return }
        perform(object)
    }
}

/// Create a closure that capture weak object.
///
/// - Parameters:
///   - object: The object to capture.
///   - perform: The action to perform if the object is alive.
/// - Returns: A closure.
public func weak<Object, Value>(_ object: Object, perform: @escaping (Object, Value) -> Void) -> (Value) -> Void where Object: AnyObject {
    return { [weak object] value in
        guard let object = object else { return }
        perform(object, value)
    }
}

/// Create a closure that capture weak object.
///
/// - Parameters:
///   - object: The object to capture.
///   - perform: The action to perform if the object is alive.
/// - Returns: A closure.
public func weak<Object, Value1, Value2>(_ object: Object, perform: @escaping (Object, Value1, Value2) -> Void) -> (Value1, Value2) -> Void where Object: AnyObject {
    return { [weak object] value1, value2 in
        guard let object = object else { return }
        perform(object, value1, value2)
    }
}

/// Create a closure that capture weak object.
///
/// - Parameters:
///   - object: The object to capture.
///   - perform: The action to perform if the object is alive.
/// - Returns: A closure.
public func weak<Object, Value1, Value2, Value3>(_ object: Object, perform: @escaping (Object, Value1, Value2, Value3) -> Void) -> (Value1, Value2, Value3) -> Void where Object: AnyObject {
    return { [weak object] value1, value2, value3 in
        guard let object = object else { return }
        perform(object, value1, value2, value3)
    }
}

/// Create a closure that capture weak object.
///
/// - Parameters:
///   - object: The object to capture.
///   - perform: The action to perform if the object is alive.
/// - Returns: A closure.
public func weak<Object, Value1, Value2, Value3, Value4>(_ object: Object, perform: @escaping (Object, Value1, Value2, Value3, Value4) -> Void) -> (Value1, Value2, Value3, Value4) -> Void where Object: AnyObject {
    return { [weak object] value1, value2, value3, value4 in
        guard let object = object else { return }
        perform(object, value1, value2, value3, value4)
    }
}
