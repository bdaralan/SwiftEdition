import UIKit


extension TextInputController {
    
    final class TagItemCell: CollectionCell {
        
        private let label = UILabel()
        private let imageLabel = UILabel()
        
        func update(with item: TextInputTagItem) {
            label.text = item.text.localized
            label.textColor = item.foreground ?? .secondaryLabel
            
            imageLabel.textColor = label.textColor
            imageLabel.isHidden = item.image == nil
            imageLabel.attributedText = item.image.map({ .init(attachment: .init(image: $0)) })
            
            backgroundColor = item.background ?? tintColor.withAlphaComponent(0.1)
        }
        
        override func setupContentContainer() {
            super.setupContentContainer()
            layer.cornerRadius = 10
            contentContainer.padding = .init(vertical: 8, horizontal: 24)
            
            label.adjustsFontForContentSizeCategory = true
            label.font = .init(style: .body)
            label.textAlignment = .center
            
            imageLabel.adjustsFontForContentSizeCategory = true
            imageLabel.font = .init(style: .callout)

            let content = UIStackView(.horizontal, spacing: 8, views: imageLabel, label)
            
            setContent(content)
        }
    }
}
