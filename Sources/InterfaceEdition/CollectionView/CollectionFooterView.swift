import UIKit


open class CollectionFooterView: UICollectionReusableView {
    
    public let contentContainer = UIStackView()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupContentContainer()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupContentContainer() {
        addAutoLayoutSubview(contentContainer)
        contentContainer.constraint(fill: self)
    }
}


extension CollectionFooterView: TableCollectionContentContainer {}
