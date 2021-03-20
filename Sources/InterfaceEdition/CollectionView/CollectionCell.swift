import UIKit


open class CollectionCell: UICollectionViewCell, ContentContainer {
    
    public let container = ContainerView()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupContainer()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupContainer() {
        contentView.addAutoLayoutSubview(container)
        container.constraint(fill: contentView)
    }
}
