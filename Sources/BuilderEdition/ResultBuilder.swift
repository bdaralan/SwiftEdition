import Foundation


@resultBuilder
public struct ResultBuilder {
    
    public static func buildBlock<Result>() -> [Result] { [] }
    
    public static func buildBlock<Result>(_ builder: Result...) -> [Result] { builder }
}


extension ResultBuilder {
    
    public static func array<Result>(@ResultBuilder builder: () -> [Result]) -> [Result] { builder() }
    
    public static func set<Result>(@ResultBuilder builder: () -> [Result]) -> Set<Result> { Set(builder()) }
}
