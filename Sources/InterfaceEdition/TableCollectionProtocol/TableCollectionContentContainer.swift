import UIKit


public protocol TableCollectionContentContainer {
    
    /// The container for the content view.
    var contentContainer: UIStackView { get }
    
    /// Setup the `contentContainer`.
    func setupContentContainer()
}


extension TableCollectionContentContainer {
    
    /// The assigned content view.
    public var assignedContent: UIView? { contentContainer.arrangedSubviews.first }
    
    /// Set the view as the only `arrangedSubviews` of the `contentContainer`.
    ///
    /// - Parameter view: The content view.
    public func setContent(_ view: UIView) {
        guard view !== assignedContent else { return }
        contentContainer.setArrangedSubviews(view)
    }
}


