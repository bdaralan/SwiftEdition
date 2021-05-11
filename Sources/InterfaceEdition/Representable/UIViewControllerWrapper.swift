import SwiftUI


public struct UIViewControllerWrapper<ViewController>: UIViewControllerRepresentable where ViewController: UIViewController {
    
    private let onMake: () -> ViewController
    private let onUpdate: ((ViewController) -> Void)?
    private let onUpdateWithContext: ((ViewController, Context) -> Void)?
    
    public init(onMake: @escaping () -> ViewController) {
        self.onMake = onMake
        onUpdate = nil
        onUpdateWithContext = nil
    }
    
    public init(onMake: @escaping () -> ViewController, onUpdate: @escaping (ViewController) -> Void) {
        self.onMake = onMake
        self.onUpdate = onUpdate
        self.onUpdateWithContext = nil
    }
    
    public init(onMake: @escaping () -> ViewController, onUpdate: @escaping (ViewController, Context) -> Void) {
        self.onMake = onMake
        self.onUpdate = nil
        self.onUpdateWithContext = onUpdate
    }
 
    public func makeUIViewController(context: Context) -> ViewController {
        onMake()
    }
    
    public func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        onUpdate?(uiViewController)
        onUpdateWithContext?(uiViewController, context)
    }
}
