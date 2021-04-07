import UIKit


extension UIFont {
    
    public convenience init(style: UIFont.TextStyle, traits: UIFontDescriptor.SymbolicTraits? = nil, design: UIFontDescriptor.SystemDesign? = nil) {
        let font = UIFont.preferredFont(forTextStyle: style)
        var descriptor = font.fontDescriptor
        
        if let traits = traits, let update = descriptor.withSymbolicTraits(traits) {
            descriptor = update
        }
        
        if let design = design, let update = descriptor.withDesign(design) {
            descriptor = update
        }
        
        self.init(descriptor: descriptor, size: 0)
    }
}
