import UIKit


open class TableHeaderFooterView: UITableViewHeaderFooterView, ContentContainer {
    
    public let container = ContainerView()
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
