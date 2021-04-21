import SwiftUI


public struct Render<ContentA, ContentB, Value>: View where ContentA: View, ContentB: View {
    
    private let ifContent: (() -> ContentA)?
    private let ifContentCondition: Bool
    
    private let mapContent: ((Value) -> ContentA)?
    private let mapContentValue: Value?
    
    private let contentB: (() -> ContentB)?
    
    public var body: some View {
        if ifContentCondition, let content = ifContent {
            content()
        } else if let value = mapContentValue, let content = mapContent {
            content(value)
        } else if let contentB = contentB {
            contentB()
        }
    }
}


extension Render {
    
    public init(if condition: Value, @ViewBuilder content: @escaping () -> ContentA, @ViewBuilder else contentB: @escaping () -> ContentB) where Value == Bool {
        ifContentCondition = condition
        ifContent = content
        mapContentValue = nil
        mapContent = nil
        self.contentB = contentB
    }
    
    public init(if condition: Bool, @ViewBuilder content: @escaping () -> ContentA) where Value == Bool, ContentB == Never {
        ifContentCondition = condition
        ifContent = content
        mapContentValue = nil
        mapContent = nil
        contentB = nil
    }
    
    public init(mapped value: Value?, @ViewBuilder content: @escaping (Value) -> ContentA, @ViewBuilder else contentB: @escaping () -> ContentB) {
        mapContentValue = value
        mapContent = content
        ifContentCondition = false
        ifContent = nil
        self.contentB = contentB
    }
    
    public init(mapped value: Value?, @ViewBuilder content: @escaping (Value) -> ContentA) where ContentB == Never {
        mapContentValue = value
        mapContent = content
        ifContentCondition = false
        ifContent = nil
        contentB = nil
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
        
        Render(if: false) {
            Text("Render(if: true)")
        } else: {
            Text("Render(if: false)")
        }
        .previewLayout(.sizeThatFits)
        
        Render(mapped: Int("nil")) { value in
            Text("THIS SHOULD NOT BE RENDED")
        } else: {
            Text("mapped nil")
        }
        .previewLayout(.sizeThatFits)
    }
}
