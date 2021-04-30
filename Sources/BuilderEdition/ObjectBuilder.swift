import Foundation


/// - Tag: ObjectBuilder
///
@resultBuilder
public struct ObjectBuilder {
    
    public static func buildBlock<Object>() -> [Object] { [] }
    
    public static func buildBlock<Object>(_ builder: Object...) -> [Object] { builder }
}


extension ObjectBuilder {
    
    public static func array<Object>(@ObjectBuilder builder: () -> [Object]) -> [Object] { builder() }
    
    public static func set<Object>(@ObjectBuilder builder: () -> [Object]) -> Set<Object> { Set(builder()) }
}
