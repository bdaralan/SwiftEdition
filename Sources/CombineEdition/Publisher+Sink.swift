import Combine


extension Publisher where Failure == Never {
    
    public func sink(bag: AnyCancellableBag, receiveValue: @escaping (Output) -> Void) {
        sink(receiveValue: receiveValue).store(in: &bag.values)
    }
    
    public func sink<Key>(bag: AnyCancellableKeyedBag<Key>, key: Key, receiveValue: @escaping (Output) -> Void) where Key: Hashable {
        bag.values[key] = sink(receiveValue: receiveValue)
    }
    
    public func sink<Object>(bag: AnyCancellableBag, weak object: Object, receiveValue: @escaping (Object, Output) -> Void) where Object: AnyObject {
        sink { [weak object] output in
            guard let object = object else { return }
            receiveValue(object, output)
        }
        .store(in: &bag.values)
    }
    
    public func sink<Object, Key>(bag: AnyCancellableKeyedBag<Key>, key: Key, weak object: Object, receiveValue: @escaping (Object, Output) -> Void) where Object: AnyObject, Key: Hashable {
        bag.values[key] = sink { [weak object] output in
            guard let object = object else { return }
            receiveValue(object, output)
        }
    }
}


// MARK: - CancellableBag Bag

public final class AnyCancellableBag {
    public var values: Set<AnyCancellable> = []
    public init() {}
    public func clear() { values = [] }
}

public final class AnyCancellableKeyedBag<Key> where Key: Hashable {
    public var values: [Key: AnyCancellable] = [:]
    public init() {}
    public func clear() { values = [:] }
}
