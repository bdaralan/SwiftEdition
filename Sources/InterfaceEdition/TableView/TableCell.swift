import UIKit


open class TableCell: UITableViewCell, ContentContainer {
    
    public let container = ContainerView()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
