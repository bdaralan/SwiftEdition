import UIKit


extension TextInputViewController {
    
    class TagItemCell: CollectionCell {
        
        private let label = UILabel()
        
        func update(with item: TextInputModel.TagItem) {
            label.text = item.text.localized
            label.textColor = item.foreground ?? .secondaryLabel
            contentContainer.backgroundColor = item.background ?? tintColor.withAlphaComponent(0.1)
        }
        
        func animateSelection() {
            let animation = CAKeyframeAnimation(keyPath: "transform.scale")
            animation.duration = 0.2
            animation.values = [1, 0.8, 1]
            contentContainer.layer.add(animation, forKey: nil)
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
