import UIKit
import AutoLayoutEdition


/// - Tag: CollectionHeaderView
///
open class CollectionHeaderView: UICollectionReusableView {
    
    public let container = ViewContainer(alignment: .fill)
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupContainer()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupContainer() {
        addSubview(container)
        container.anchor.pinTo(self)
    }
}
