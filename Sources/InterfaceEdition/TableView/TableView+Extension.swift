import UIKit


extension UITableView {
    
    public func registerCell<Cell>(_ cell: Cell.Type) where Cell: UITableViewCell {
        register(cell, forCellReuseIdentifier: "\(cell.self)")
    }
    
    public func dequeueCell<Cell>(_ cell: Cell.Type, for indexPath: IndexPath) -> Cell where Cell: UITableViewCell {
        dequeueReusableCell(withIdentifier: "\(cell.self)", for: indexPath) as! Cell
    }
    
    public func registerHeaderFooterView<HeaderFooter>(_ view: HeaderFooter.Type) where HeaderFooter: UITableViewHeaderFooterView {
        register(view, forHeaderFooterViewReuseIdentifier: "\(view.self)")
    }
    
    public func dequeueHeaderFooterView<HeaderFooter>(_ view: HeaderFooter.Type) -> HeaderFooter where HeaderFooter: UITableViewHeaderFooterView {
        dequeueReusableHeaderFooterView(withIdentifier: "\(view.self)") as! HeaderFooter
    }
}
