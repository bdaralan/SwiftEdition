//import UIKit
//
//
//// MARK: - TagItemCell
//
//extension TextInputController {
//    
//    final class TagItemCell: CollectionCell {
//        
//        private let label = UILabel()
//        private let imageLabel = UILabel()
//        
//        func update(with item: TextInputTagItem) {
//            label.text = item.text.localized
//            label.isHidden = item.text.isEmpty
//            
//            imageLabel.attributedText = item.image.map({ .init(attachment: .init(image: $0)) })
//            imageLabel.isHidden = item.image == nil
//            
//            let foreground = item.foreground ?? .secondaryLabel
//            label.textColor = foreground
//            imageLabel.textColor = foreground
//            
//            backgroundColor = item.background ?? tintColor.withAlphaComponent(0.1)
//        }
//        
//        override func setupContentContainer() {
//            super.setupContentContainer()
//            layer.cornerRadius = 10
//            contentContainer.padding = .init(vertical: 8, horizontal: 24)
//            
//            label.adjustsFontForContentSizeCategory = true
//            label.font = .init(style: .body)
//            label.textAlignment = .center
//            
//            imageLabel.adjustsFontForContentSizeCategory = true
//            imageLabel.font = .init(style: .callout)
//
//            let content = UIStackView(.horizontal, spacing: 8, views: imageLabel, label)
//            
//            setContent(content)
//        }
//    }
//}
//
//
//// MARK: - ToggleItemCell
//
//extension TextInputController {
//    
//    final class ToggleItemCell: CollectionCell {
//        
//        private let label = UILabel()
//        private let imageLabel = UILabel()
//        
//        func update(with item: TextInputToggleItem) {
//            let active = item.active
//            
//            let text = active ? item.text.active : item.text.inactive
//            label.text = text.localized
//            label.isHidden = text.isEmpty
//            
//            let image = active ? item.image.active : item.image.inactive
//            imageLabel.attributedText = image.map({ .init(attachment: .init(image: $0)) })
//            imageLabel.isHidden = image == nil
//            
//            let foreground = active ? item.foreground.active : item.foreground.inactive
//            label.textColor = foreground ?? .secondaryLabel
//            imageLabel.textColor = foreground ?? .secondaryLabel
//            
//            let background = active ? item.background.active : item.background.inactive
//            backgroundColor = background ?? tintColor.withAlphaComponent(0.1)
//        }
//        
//        override func setupContentContainer() {
//            super.setupContentContainer()
//            layer.cornerRadius = 10
//            contentContainer.padding = .init(vertical: 8, horizontal: 24)
//            
//            label.adjustsFontForContentSizeCategory = true
//            label.font = .init(style: .body)
//            label.textAlignment = .center
//            
//            imageLabel.adjustsFontForContentSizeCategory = true
//            imageLabel.font = .init(style: .callout)
//
//            let content = UIStackView(.horizontal, spacing: 8, views: imageLabel, label)
//            
//            setContent(content)
//        }
//    }
//}
