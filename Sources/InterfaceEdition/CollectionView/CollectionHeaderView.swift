import UIKit


open class CollectionHeaderView: UICollectionReusableView {
    
    public let contentContainer = UIStackView()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupContentContainer()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupContentContainer() {
        addSubview(contentContainer, useAutoLayout: true)
        contentContainer.constraint(fill: self)
    }
}


extension CollectionHeaderView: TableCollectionContentContainer {}
