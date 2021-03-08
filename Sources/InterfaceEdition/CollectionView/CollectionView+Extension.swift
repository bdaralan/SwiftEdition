import UIKit


extension UICollectionView {
    
    public func registerCell<Cell>(_ cell: Cell.Type) where Cell: UICollectionViewCell {
        register(cell, forCellWithReuseIdentifier: "\(cell.self)")
    }
    
    public func dequeueCell<Cell>(_ cell: Cell.Type, for indexPath: IndexPath) -> Cell where Cell: UICollectionViewCell {
        dequeueReusableCell(withReuseIdentifier: "\(cell.self)", for: indexPath) as! Cell
    }
    
    public func registerHeaderView<Header>(_ header: Header.Type) where Header: UICollectionReusableView {
        let headerKind = UICollectionView.elementKindSectionHeader
        let id = "\(header.self)"
        register(header, forSupplementaryViewOfKind: headerKind, withReuseIdentifier: id)
    }
    
    public func dequeueHeaderView<Header>(_ header: Header.Type, for indexPath: IndexPath) -> Header where Header: UICollectionReusableView {
        let headerKind = UICollectionView.elementKindSectionHeader
        let id = "\(header.self)"
        return dequeueReusableSupplementaryView(ofKind: headerKind, withReuseIdentifier: id, for: indexPath) as! Header
    }
    
    public func registerFooterView<Footer>(_ footer: Footer.Type) where Footer: UICollectionReusableView {
        let footerKind = UICollectionView.elementKindSectionFooter
        let id = "\(footer.self)"
        register(footer, forSupplementaryViewOfKind: footerKind, withReuseIdentifier: id)
    }
    
    public func dequeueFooterView<Footer>(_ footer: Footer.Type, for indexPath: IndexPath) -> Footer where Footer: UICollectionReusableView {
        let footerKind = UICollectionView.elementKindSectionFooter
        let id = "\(footer.self)"
        return dequeueReusableSupplementaryView(ofKind: footerKind, withReuseIdentifier: id, for: indexPath) as! Footer
    }
}
