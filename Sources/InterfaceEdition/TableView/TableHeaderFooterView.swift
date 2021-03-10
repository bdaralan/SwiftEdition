import UIKit


open class TableHeaderFooterView: UITableViewHeaderFooterView {
    
    public let contentContainer = UIStackView()
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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


extension TableHeaderFooterView: TableCollectionContentContainer {}
