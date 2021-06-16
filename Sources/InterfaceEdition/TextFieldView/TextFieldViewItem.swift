import Foundation


// MARK: - Protocol

public protocol TextFieldViewItem {
    
    var id: String { get }
}


// MARK: - Builder

@resultBuilder public enum TextFieldViewItemBuilder {
    
    public static func buildBlock(_ components: [TextFieldViewItem]...) -> [TextFieldViewItem] {
        components.flatMap({ $0 })
    }
    
    public static func buildExpression(_ expression: TextFieldViewItem) -> [TextFieldViewItem] {
        [expression]
    }
    
    public static func buildOptional(_ component: [TextFieldViewItem]?) -> [TextFieldViewItem] {
        component ?? []
    }
    
    public static func buildEither(first component: [TextFieldViewItem]) -> [TextFieldViewItem] {
        component
    }
    
    public static func buildEither(second component: [TextFieldViewItem]) -> [TextFieldViewItem] {
        component
    }
}
