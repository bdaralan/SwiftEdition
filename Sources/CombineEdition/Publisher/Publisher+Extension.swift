import Combine


extension Publisher where Failure == Never {
    
    /// Assigns value to a property on an object.
    ///
    /// The object is captured as `[weak self]` in `sink(receiveValue:)` method.
    public func assign<Object>(to keyPath: ReferenceWritableKeyPath<Object, Output>, onWeak object: Object) -> AnyCancellable where Object: AnyObject {
        sink { [weak object, weak keyPath] output in
            guard let object = object, let keyPath = keyPath else { return }
            object[keyPath: keyPath] = output
        }
    }
    
    public func sink(storeIn set: inout Set<AnyCancellable>, receiveValue: @escaping (Output) -> Void) {
        sink { output in
            receiveValue(output)
        }
        .store(in: &set)
    }
    
    public func sink<Collection>(storeIn collection: inout Collection, receiveValue: @escaping (Output) -> Void) where Collection: RangeReplaceableCollection, Collection.Element == AnyCancellable {
        sink { output in
            receiveValue(output)
        }
        .store(in: &collection)
    }
    
    public func sink<Object>(weak object: Object, storeIn set: inout Set<AnyCancellable>, receiveValue: @escaping (Object, Output) -> Void) where Object: AnyObject {
        sink { [weak object] output in
            guard let object = object else { return }
            receiveValue(object, output)
        }
        .store(in: &set)
    }
    
    public func sink<Object, Collection>(weak object: Object, storeIn collection: inout Collection, receiveValue: @escaping (Object, Output) -> Void) where Object: AnyObject, Collection: RangeReplaceableCollection, Collection.Element == AnyCancellable {
        sink { [weak object] output in
            guard let object = object else { return }
            receiveValue(object, output)
        }
        .store(in: &collection)
    }
}
