import SwiftUI


public struct Render<Content, Value>: View where Content: View {
    
    private let ifContent: (() -> Content)?
    private let ifContentCondition: Bool
    
    private let mapContent: ((Value) -> Content)?
    private let mapContentValue: Value?
    
    public init(mapped value: Value?, content: @escaping (Value) -> Content) {
        mapContent = content
        mapContentValue = value
        ifContent = nil
        ifContentCondition = false
    }
    
    public var body: some View {
        if ifContentCondition, let content = ifContent {
            content()
        }
        if let value = mapContentValue, let content = mapContent {
            content(value)
        }
    }
}


extension Render where Value == Never {
    
    public init(if condition: Bool, content: @escaping () -> Content) {
        ifContentCondition = condition
        ifContent = content
        mapContent = nil
        mapContentValue = nil
    }
}


struct Render_Previews: PreviewProvider {
    static var previews: some View {
        Render(if: true) {
            Text("Render(if: true)")
        }
        .previewLayout(.sizeThatFits)
        
        Render(if: false) {
            Text("THIS SHOULD NOT BE RENDED")
        }
        .previewLayout(.sizeThatFits)
        
        Render(mapped: Int("nil")) { value in
            Text("THIS SHOULD NOT BE RENDED")
        }
        .previewLayout(.sizeThatFits)
        
        Render(mapped: Int("4")) { value in
            Text("Render(mapped: Int('4'))")
        }
        .previewLayout(.sizeThatFits)
    }
}
