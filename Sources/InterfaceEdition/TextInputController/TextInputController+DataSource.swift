import UIKit


extension TextInputController {
    
    typealias ItemDataSource = UICollectionViewDiffableDataSource<Int, ItemDataSourceItem>
    typealias ItemDataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, ItemDataSourceItem>
    
    enum ItemDataSourceItem: Hashable {
        case tag(TextInputTagItem)
        case toggle(TextInputToggleItem)
    }
}


protocol TextInputControllerItemDataSourceConvertible {
    
    /// Create a `TextInputController.ItemDataSourceItem` of itself.
    func item() -> TextInputController.ItemDataSourceItem
}


extension TextInputTagItem: TextInputControllerItemDataSourceConvertible {
    
    func item() -> TextInputController.ItemDataSourceItem { .tag(self) }
}


extension TextInputToggleItem: TextInputControllerItemDataSourceConvertible {
    
    func item() -> TextInputController.ItemDataSourceItem { .toggle(self) }
}
