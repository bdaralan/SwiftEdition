import SwiftUI


struct TextInputItemView: View {
    
    @ObservedObject var model: TextInputModel
        
    private let rows = [GridItem(.flexible(minimum: 10))]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, alignment: .top, spacing: 12) {
                ForEach(model.item.list, id: \.id) { item in
                    ItemViewFactory(itemKind: item.type)
                        .environmentObject(model)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
    }
}


// MARK: - ItemViewFactory

extension TextInputItemView {
    
    struct ItemViewFactory: View {
        let itemKind: TextInputItemType
        var body: some View {
            switch itemKind {
            case let .tag(item): TextInputItemView.TagItemView(item: item)
            case let .toggle(item): TextInputItemView.ToggleItemView(item: item)
            }
        }
    }
}


// MARK: - TagItemView

extension TextInputItemView {
    
    struct TagItemView: View {
        
        @EnvironmentObject private var model: TextInputModel
        
        let item: TextInputTagItem
        
        var body: some View {
            HStack {
                Render(mapped: image) { image in
                    Image(uiImage: image)
                        .foregroundColor(foreground)
                }
                Render(if: !item.text.isEmpty) {
                    Text(LocalizedStringKey(item.text))
                        .foregroundColor(foreground)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(background)
            .cornerRadius(10)
            .onTapGesture(perform: handleTapped)
        }
        
        var image: UIImage? {
            guard let image = item.image else { return nil }
            guard image.renderingMode == .automatic else { return image }
            return image.withRenderingMode(.alwaysTemplate)
        }
        
        var foreground: Color {
            guard let color = item.foreground else { return .secondary }
            return Color(color)
        }
        
        var background: Color {
            guard let color = item.background else { return Color.accentColor.opacity(0.1) }
            return Color(color)
        }
        
        private func handleTapped() {
            item.action?(item)
        }
    }
}


// MARK: - ToggleItemView

extension TextInputItemView {
    
    struct ToggleItemView: View {
        
        @EnvironmentObject private var model: TextInputModel
        
        let item: TextInputToggleItem
        
        var body: some View {
            HStack {
                Render(mapped: image) { image in
                    Image(uiImage: image)
                        .foregroundColor(foreground)
                }
                Render(if: !item.text.isEmpty) {
                    Text(LocalizedStringKey(item.text))
                        .foregroundColor(foreground)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(background)
            .cornerRadius(10)
            .onTapGesture(perform: handleTapped)
        }
        
        private var image: UIImage? {
            guard let image = item.image else { return nil }
            guard image.renderingMode == .automatic else { return image }
            return image.withRenderingMode(.alwaysTemplate)
        }
        
        private var foreground: Color {
            guard let color = item.foreground else { return Color.secondary }
            return Color(color)
        }
        
        private var background: Color {
            guard let color = item.background else { return Color.accentColor.opacity(0.1) }
            return Color(color)
        }
        
        private func handleTapped() {
            var item = self.item
            item.active.toggle()
            model.item.update(item)
            item.action(item)
        }
    }
}


// MARK: - Preview

struct TextInputItemView_Previews: PreviewProvider {
    static let model = TextInputViewController_Previews.model
    static var previews: some View {
        TextInputItemView(model: model)
    }
}
