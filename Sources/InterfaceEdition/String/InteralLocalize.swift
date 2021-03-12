import Foundation


extension String {
    
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}


extension String {
    
    func empty(replacement: String) -> String {
        isEmpty ? replacement : self
    }
}
