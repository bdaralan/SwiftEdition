import SwiftUI


public struct UIViewControllerWrapper<ViewController>: UIViewControllerRepresentable where ViewController: UIViewController {
    
    private let onMake: () -> ViewController
    private let onUpdate: (() -> Void)?
    private let onUpdateController: ((ViewController) -> Void)?
    private let onUpdateControllerWithContext: ((ViewController, Context) -> Void)?
    
    public init(onMake: @escaping () -> ViewController) {
        self.onMake = onMake
        onUpdate = nil
        onUpdateController = nil
        onUpdateControllerWithContext = nil
    }
    
    public init(onMake: @escaping () -> ViewController, onUpdate: @escaping () -> Void) {
        self.onMake = onMake
        self.onUpdate = onUpdate
        self.onUpdateController = nil
        self.onUpdateControllerWithContext = nil
    }
    
    public init(onMake: @escaping () -> ViewController, onUpdate: @escaping (ViewController) -> Void) {
        self.onMake = onMake
        self.onUpdate = nil
        self.onUpdateController = onUpdate
        self.onUpdateControllerWithContext = nil
    }
    
    public init(onMake: @escaping () -> ViewController, onUpdate: @escaping (ViewController, Context) -> Void) {
        self.onMake = onMake
        self.onUpdate = nil
        self.onUpdateController = nil
        self.onUpdateControllerWithContext = onUpdate
    }
 
    public func makeUIViewController(context: Context) -> ViewController {
        onMake()
    }
    
    public func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        onUpdate?()
        onUpdateController?(uiViewController)
        onUpdateControllerWithContext?(uiViewController, context)
    }
}
