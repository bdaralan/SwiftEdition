import SwiftUI
import Combine


extension View {
    
    func onReceive<P>(_ publisher: P, assignTo binding: Binding<P.Output>) -> some View where P: Publisher, P.Failure == Never {
        onReceive(publisher, perform: { binding.wrappedValue = $0 })
    }
    
    func onChange<Value>(of value: Value, assignTo binding: Binding<Value>) -> some View where Value: Equatable {
        onChange(of: value, perform: { binding.wrappedValue = $0 })
    }
}
