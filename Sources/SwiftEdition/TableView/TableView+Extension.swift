import UIKit


public extension UITableView {
    
    func registerCell<Cell>(_ cell: Cell.Type) where Cell: UITableViewCell {
        register(cell, forCellReuseIdentifier: "\(cell.self)")
    }
    
    func dequeueCell<Cell>(_ cell: Cell.Type, for indexPath: IndexPath) -> Cell where Cell: UITableViewCell {
        dequeueReusableCell(withIdentifier: "\(cell.self)", for: indexPath) as! Cell
    }
    
    func registerHeaderFooterView<HeaderFooter>(_ view: HeaderFooter.Type) where HeaderFooter: UITableViewHeaderFooterView {
        register(view, forHeaderFooterViewReuseIdentifier: "\(view.self)")
    }
    
    func dequeueHeaderFooterView<HeaderFooter>(_ view: HeaderFooter.Type) -> HeaderFooter where HeaderFooter: UITableViewHeaderFooterView {
        dequeueReusableHeaderFooterView(withIdentifier: "\(view.self)") as! HeaderFooter
    }
}
