import SwiftUI


extension View {
    
    /// Presents a sheet using the given item as a data source for the sheet’s content.
    ///
    /// Use this method when you need to present a modal view with content from a custom data source.
    ///
    /// - Parameters:
    ///   - item: A binding to an optional source of truth for the sheet.
    ///   - value: A value that indicate which value should the sheet be presented.
    ///   - onDismiss: The closure to execute when dismissing the sheet.
    ///   - content: A closure returning the content of the sheet.
    public func sheet<Item, Content>(
        item: Binding<Item?>,
        equals value: Item,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View where Item: Identifiable, Content: View {
        sheet(item: item.wrappedValue?.id == value.id ? item : .constant(nil), onDismiss: onDismiss, content: { _ in content() })
    }
}
