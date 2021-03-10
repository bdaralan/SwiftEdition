import UIKit


open class CollectionCell: UICollectionViewCell {
    
    public let contentContainer = UIStackView()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupContentContainer()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupContentContainer() {
        contentView.addAutoLayoutSubview(contentContainer)
        contentContainer.constraint(fill: contentView)
    }
}


extension CollectionCell: TableCollectionContentContainer {}
