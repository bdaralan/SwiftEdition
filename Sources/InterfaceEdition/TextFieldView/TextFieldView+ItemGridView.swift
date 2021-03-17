import SwiftUI


// MARK: - ItemGridView

extension TextFieldView {
    
    struct ItemGridView: View {
        
        @EnvironmentObject var model: TextFieldModel
        
        private let rows = [GridItem(.flexible(minimum: 10))]
        
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows, alignment: .top, spacing: 12) {
                    ForEach(model.item.items, id: \.id) { item in
                        ItemView(item: item)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .animation(.spring())
            }
            .environmentObject(model)
        }
    }
}


// MARK: - ItemView

extension TextFieldView.ItemGridView {
    
    struct ItemView: View {
        
        let item: TextFieldItem
        
        var body: some View {
            switch item.type {
            case let .tag(item): TextFieldView.ItemGridView.TagItemView(item: item)
            case let .toggle(item): TextFieldView.ItemGridView.ToggleItemView(item: item)
            }
        }
    }
    
    struct ItemViewLabel: View {
        
        let text: String
        
        let image: UIImage?
        
        var body: some View {
            ZStack {
                Text(" ").hidden()
                HStack {
                    Render(mapped: iconImage) { image in
                        Image(uiImage: image)
                    }
                    Render(if: !text.isEmpty) {
                        Text(LocalizedStringKey(text))
                    }
                }
            }
        }
        
        private var iconImage: UIImage? {
            guard let image = image else { return nil }
            guard image.renderingMode == .automatic else { return image }
            let configuration = UIImage.SymbolConfiguration(scale: .small)
            return image.withRenderingMode(.alwaysTemplate).withConfiguration(configuration)
        }
    }
}


// MARK: - TagItemView

extension TextFieldView.ItemGridView {
    
    struct TagItemView: View {
        
        let item: TextFieldTagItem
        
        @State private var scale: CGFloat = 1
        
        var body: some View {
            TextFieldView.ItemGridView.ItemViewLabel(text: item.text, image: item.image)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .foregroundColor(foreground)
                .background(background)
                .cornerRadius(10)
                .scaleEffect(scale, anchor: .center)
                .onTapGesture(perform: handleTapped)
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
                scale = 0.75
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                    withAnimation(animation) { scale = 1 }
                }
            }
        }
    }
}


// MARK: - ToggleItemView

extension TextFieldView.ItemGridView {
    
    struct ToggleItemView: View {
        
        @EnvironmentObject private var model: TextFieldModel
        
        let item: TextFieldToggleItem
        
        @State private var scale: CGFloat = 1
        
        var body: some View {
            TextFieldView.ItemGridView.ItemViewLabel(text: item.text, image: item.image)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .foregroundColor(foreground)
                .background(background)
                .cornerRadius(10)
                .scaleEffect(scale, anchor: .center)
                .onTapGesture(perform: handleTapped)
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
            if item.togglesActiveStateAutomatically {
                var updateItem = item
                updateItem.active.toggle()
                model.item.update(updateItem)
                item.action(updateItem)
            } else {
                item.action(item)
            }
        }
        
        private func animateTapAnimation() {
            let animation = Animation.spring()
            withAnimation(animation) {
                scale = 0.75
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                    withAnimation(animation) { scale = 1 }
                }
            }
        }
    }
}


// MARK: - Previews

struct TextFieldItemGridView_Previews: PreviewProvider {
    static let model: TextFieldModel = {
        let model = TextFieldModel()
        model.header.title = "Text Input"
        model.field.text = "Password"
        model.field.placeholder = "Placeholder"
        model.prompt.text = "Prompt"
        
        var delete = TextFieldTagItem(text: "Delete") { item in
            model.item.delete(itemID: item.id)
        }
        delete.image = UIImage(systemName: "trash")
        delete.foreground = .systemRed
        delete.background = delete.foreground?.withAlphaComponent(0.1)
        
        var noAction = TextFieldTagItem(text: "No Action")
        
        let action = TextFieldTagItem(text: "Action") { item in
            model.action.perform(.shakeTextField)
        }
        
        var toggle = TextFieldToggleItem(active: false) { item in
            model.field.isSecureEntry = item.active
        }
        toggle.images.active = UIImage(systemName: "eye")
        toggle.images.inactive = UIImage(systemName: "eye.slash")
        toggle.backgrounds.active = UIColor.systemRed.withAlphaComponent(0.1)
        toggle.backgrounds.inactive = UIColor.systemGreen.withAlphaComponent(0.1)
        
        var toggle2 = TextFieldToggleItem(active: true) { item in
            var item = item
            item.active.toggle()
            model.item.update(item)
        }
        toggle2.togglesActiveStateAutomatically = false
        toggle2.texts = ("On", "Off")

        model.item.items = [delete, noAction, action, toggle, toggle2]
        return model
    }()
    static var previews: some View {
        TextFieldView.ItemGridView().environmentObject(model)
    }
}
