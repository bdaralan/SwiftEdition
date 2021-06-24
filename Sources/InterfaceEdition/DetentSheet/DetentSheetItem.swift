import UIKit


@available(iOS 15.0, *)
public struct DetentSheetItem: Equatable {
    
    public var detent: Detent?
    
    public var detents: [Detent] = [.medium, .large]
    
    public var smallestUndimmedDetent: Detent?
    
    public var prefersGrabberVisible = false
    
    public var prefersEdgeAttachedInCompactHeight = false
    
    public var prefersScrollingExpandsWhenScrolledToEdge = true
    
    public var widthFollowsPreferredContentSizeWhenEdgeAttached = false
    
    public var allowInteractiveDismissal = true
}


@available(iOS 15.0, *)
extension DetentSheetItem {
    
    public enum Detent {
        case medium
        case large
        
        var uiDetentID: UISheetPresentationController.Detent.Identifier {
            switch self {
            case .medium: return .medium
            case .large: return .large
            }
        }
        
        var uiDetent: UISheetPresentationController.Detent {
            switch self {
            case .medium: return .medium()
            case .large: return .large()
            }
        }
    }
    
    public enum DismissReason {
        case action
        case interaction
        case prevention
    }
}
