import UIKit
import AutoLayoutEdition


/// A `UICollectionViewCell` subclass that use `ViewContainer` as `contentView`.
///
/// General usage is to override `setup()` or `setupContainer()` and call `super`.
/// Then assign a view to `container.view`.
///
/// - Tag: CollectionCell
///
open class CollectionCell: UICollectionViewCell {
    
    public let container = ViewContainer(alignment: .fill)
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setup() {
        setupContainer()
    }
    
    open func setupContainer() {
        contentView.addSubview(container)
        container.anchor.pinTo(contentView)
    }
}
