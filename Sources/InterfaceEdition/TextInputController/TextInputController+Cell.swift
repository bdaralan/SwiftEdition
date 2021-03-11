import UIKit


extension TextInputController {
    
    final class TagItemCell: CollectionCell {
        
        private let label = UILabel()
        private let imageLabel = UILabel()
        
        func update(with item: TextInputTagItem) {
            update(text: item.text)
            update(image: item.image)
            update(foreground: item.foreground)
            update(background: item.background)
        }
        
        func update(text: String) {
            label.text = text.localized
            label.isHidden = text.isEmpty
        }
        
        func update(image: UIImage?) {
            imageLabel.attributedText = image.map({ .init(attachment: .init(image: $0)) })
            imageLabel.isHidden = image == nil
        }
        
        func update(foreground: UIColor?) {
            let color = foreground ?? .secondaryLabel
            label.textColor = color
            imageLabel.textColor = color
        }
        
        func update(background: UIColor?) {
            backgroundColor = background ?? tintColor.withAlphaComponent(0.1)
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
