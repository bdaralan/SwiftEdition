import UIKit
import AutoLayoutEdition


open class TableCell: UITableViewCell {
    
    public let container = ViewContainer(alignment: .fill)
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContainer()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupContainer() {
        contentView.addSubview(container)
        container.anchor.pinTo(contentView)
    }
}
