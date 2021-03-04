import UIKit


public protocol TableCollectionContentContainer {
    
    /// The container for the content view.
    var contentContainer: UIStackView { get }
    
    /// Setup the `contentContainer`.
    func setupContentContainer()
}


public extension TableCollectionContentContainer {
    
    /// The assigned content view.
    var assignedContent: UIView? { contentContainer.arrangedSubviews.first }
    
    /// The padding of the `contentContainer`.
    var padding: NSDirectionalEdgeInsets {
        get { contentContainer.padding}
        set { contentContainer.padding = newValue }
    }
    
    /// Set the view as the only `arrangedSubviews` of the `contentContainer`.
    ///
    /// - Parameter view: The content view.
    func setContent(_ view: UIView) {
        guard view !== assignedContent else { return }
        contentContainer.setArrangedSubviews(view)
    }
    
    /// Remove the `assignedContent` from the `contentContainer`.
    func removeContent() {
        assignedContent?.removeFromSuperview()
    }
}


