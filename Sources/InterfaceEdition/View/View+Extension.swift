import SwiftUI
import Combine


extension View {
    
    func onReceive<P>(_ publisher: P, assignTo binding: Binding<P.Output>) -> some View where P: Publisher, P.Failure == Never {
        onReceive(publisher, perform: { binding.wrappedValue = $0 })
    }
}
