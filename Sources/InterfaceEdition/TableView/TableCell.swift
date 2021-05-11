import UIKit
import AutoLayoutEdition


/// A `UITableViewCell` subclass that use `ViewContainer` as `contentView`.
///
/// General usage is to override `setup()` or `setupContainer()` and call `super`.
/// Then assign a view to `container.view`.
///
open class TableCell: UITableViewCell {
    
    public let container = ViewContainer(alignment: .fill)
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
