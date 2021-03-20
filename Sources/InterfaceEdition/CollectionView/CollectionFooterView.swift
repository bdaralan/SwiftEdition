import UIKit


open class CollectionFooterView: UICollectionReusableView, ContentContainer {
    
    public let container = ContainerView()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupContainer()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupContainer() {
        addAutoLayoutSubview(container)
        container.constraint(fill: self)
    }
}
