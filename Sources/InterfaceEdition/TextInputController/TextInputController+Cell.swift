import UIKit


extension TextInputController {
    
    final class TagItemCell: CollectionCell {
        
        private let label = UILabel()
        
        func update(with item: TextInputTagItem) {
            label.text = item.text.localized
            label.textColor = item.foreground ?? .secondaryLabel
            contentContainer.backgroundColor = item.background ?? tintColor.withAlphaComponent(0.1)
        }
        
        override func setupContentContainer() {
            super.setupContentContainer()
            
            contentContainer.padding = .init(vertical: 8, horizontal: 24)
            contentContainer.layer.cornerRadius = 10
            
            label.adjustsFontForContentSizeCategory = true
            label.font = .init(style: .body)
            label.textAlignment = .center
            
            setContent(label)
        }
    }
}
