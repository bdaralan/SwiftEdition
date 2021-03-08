import UIKit


extension UIFont {
    
    public convenience init(style: UIFont.TextStyle, traits: UIFontDescriptor.SymbolicTraits? = nil, design: UIFontDescriptor.SystemDesign? = nil) {
        let font = UIFont.preferredFont(forTextStyle: style)
        var descriptor = font.fontDescriptor
        
        if let traits = traits, let applied = descriptor.withSymbolicTraits(traits) {
            descriptor = applied
        }
        
        if let design = design, let applied = descriptor.withDesign(design) {
            descriptor = applied
        }
        
        self.init(descriptor: descriptor, size: 0)
    }
}
