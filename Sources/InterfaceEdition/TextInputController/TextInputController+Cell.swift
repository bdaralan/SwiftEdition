import UIKit


// MARK: - TagItemCell

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


// MARK: - ToggleItemCell

extension TextInputController {
    
    final class ToggleItemCell: CollectionCell {
        
        private let label = UILabel()
        private let imageLabel = UILabel()
        
        func update(with item: TextInputToggleItem) {
            update(text: item.text, active: item.active)
            update(image: item.image, active: item.active)
            update(foreground: item.foreground, active: item.active)
            update(background: item.background, active: item.active)
        }
        
        private func update(text: TextInputToggleItem.Property<String?>, active: Bool) {
            let text = active ? text.active ?? "" : text.inactive ?? text.active ?? ""
            label.text = text.localized
            label.isHidden = text.isEmpty
        }
        
        private func update(image: TextInputToggleItem.Property<UIImage?>, active: Bool) {
            let image = active ? image.active : image.inactive ?? image.active
            imageLabel.attributedText = image.map({ .init(attachment: .init(image: $0)) })
            imageLabel.isHidden = image == nil
        }
        
        private func update(foreground: TextInputToggleItem.Property<UIColor?>, active: Bool) {
            let color = active ? foreground.active : foreground.inactive ?? foreground.active
            label.textColor = color ?? .secondaryLabel
            imageLabel.textColor = color ?? .secondaryLabel
        }
        
        private func update(background: TextInputToggleItem.Property<UIColor?>, active: Bool) {
            let color = active ? background.active : background.inactive ?? background.active
            backgroundColor = color ?? tintColor.withAlphaComponent(0.1)
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
