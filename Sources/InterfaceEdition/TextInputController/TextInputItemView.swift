import SwiftUI


struct TextInputItemView: View {
    
    @ObservedObject var model: TextInputModel
        
    private let rows = [GridItem(.flexible(minimum: 10))]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, alignment: .top, spacing: 12) {
                ForEach(model.item.items, id: \.id) { item in
                    ItemView(item: item)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
            .animation(.spring())
        }
        .environmentObject(model)
    }
}


// MARK: - ItemView

extension TextInputItemView {
    
    struct ItemView: View {
        let item: TextInputItem
        var body: some View {
            switch item.type {
            case let .tag(item): TextInputItemView.TagItemView(item: item)
            case let .toggle(item): TextInputItemView.ToggleItemView(item: item)
            }
        }
    }
}


// MARK: - TagItemView

extension TextInputItemView {
    
    struct TagItemView: View {
        
        let item: TextInputTagItem
        
        @State private var scale: CGFloat = 1
        
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
            .scaleEffect(scale, anchor: .center)
            .onTapGesture(perform: handleTapped)
        }
        
        private var image: UIImage? {
            guard let image = item.image else { return nil }
            guard image.renderingMode == .automatic else { return image }
            return image.withRenderingMode(.alwaysTemplate)
        }
        
        private var foreground: Color {
            guard let color = item.foreground else { return .secondary }
            return Color(color)
        }
        
        private var background: Color {
            if let color = item.background {
                return Color(color)
            }
            let color = item.action == nil ? Color.secondary : .accentColor
            return color.opacity(0.1)
        }
        
        private func handleTapped() {
            guard let action = item.action else { return }
            animateTapAnimation()
            action(item)
        }
        
        private func animateTapAnimation() {
            let animation = Animation.spring()
            withAnimation(animation) {
                scale = 0.5
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                    withAnimation(animation) { scale = 1 }
                }
            }
        }
    }
}


// MARK: - ToggleItemView

extension TextInputItemView {
    
    struct ToggleItemView: View {
        
        @EnvironmentObject private var model: TextInputModel
        
        let item: TextInputToggleItem
        
        @State private var scale: CGFloat = 1
        
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
            .scaleEffect(scale, anchor: .center)
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
            animateTapAnimation()
            if item.updatesActiveStateAutomatically {
                var updatedItem = self.item
                updatedItem.active.toggle()
                model.item.update(updatedItem)
                updatedItem.action(updatedItem)
            } else {
                item.action(item)
            }
        }
        
        private func animateTapAnimation() {
            let animation = Animation.spring()
            withAnimation(animation) {
                scale = 0.5
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                    withAnimation(animation) { scale = 1 }
                }
            }
        }
    }
}


// MARK: - Preview

struct TextInputItemView_Previews: PreviewProvider {
    static let model: TextInputModel = {
        let model = TextInputModel()
        model.header.title = "Text Input"
        model.field.text = "Password"
        model.field.placeholder = "Placeholder"
        model.prompt.text = "Prompt"
        
        var delete = TextInputTagItem(text: "Delete") { item in
            model.item.delete(itemID: item.id)
        }
        delete.image = UIImage(systemName: "trash")
        delete.foreground = .systemRed
        delete.background = delete.foreground?.withAlphaComponent(0.1)
        
        var noAction = TextInputTagItem(text: "No Action")
        
        let action = TextInputTagItem(text: "Action") { item in
            model.action.perform(.shakeTextField)
        }
        
        var toggle = TextInputToggleItem(active: false) { item in
            model.field.isSecureEntry = item.active
        }
        toggle.imageValue.active = UIImage(systemName: "eye")
        toggle.imageValue.inactive = UIImage(systemName: "eye.slash")
        toggle.backgroundValue.active = UIColor.systemRed.withAlphaComponent(0.1)
        toggle.backgroundValue.inactive = UIColor.systemGreen.withAlphaComponent(0.1)
        
        var toggle2 = TextInputToggleItem(active: true) { item in
            var item = item
            item.active.toggle()
            model.item.update(item)
        }
        toggle2.updatesActiveStateAutomatically = false
        toggle2.textValue = ("On", "Off")

        model.item.items = [delete, noAction, action, toggle, toggle2]
        return model
    }()
    static var previews: some View {
        TextInputItemView(model: model)
    }
}
