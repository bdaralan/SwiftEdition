import UIKit


public protocol ContentContainer {
    
    /// The container for the content view.
    var container: ContainerView<UIView> { get }
    
    /// Setup the `contentContainer`.
    func setupContainer()
}


extension ContentContainer {
    
    /// The assigned content view.
    public var content: UIView? {
        get { container.content }
        set { container.content = newValue }
    }
}


