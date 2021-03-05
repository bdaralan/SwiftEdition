import SwiftUI


@available(iOS 13.0.0, *)
public struct UIViewWrapper<View>: UIViewRepresentable where View: UIView {
    
    private let onMake: () -> View
    private let onUpdate: ((View) -> Void)?
    private let onUpdateWithContext: ((View, Context) -> Void)?
    
    public init(onMake: @escaping () -> View) {
        self.onMake = onMake
        onUpdate = nil
        onUpdateWithContext = nil
    }
    
    public init(onMake: @escaping () -> View, onUpdate: @escaping (View) -> Void) {
        self.onMake = onMake
        self.onUpdate = onUpdate
        self.onUpdateWithContext = nil
    }
    
    public init(onMake: @escaping () -> View, onUpdate: @escaping (View, Context) -> Void) {
        self.onMake = onMake
        self.onUpdate = nil
        self.onUpdateWithContext = onUpdate
    }
 
    public func makeUIView(context: Context) -> View {
        onMake()
    }
    
    public func updateUIView(_ uiView: View, context: Context) {
        onUpdate?(uiView)
        onUpdateWithContext?(uiView, context)
    }
}
