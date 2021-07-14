import SwiftUI


/// A text field view used to take input from keyboard.
///
/// The view supports header, field, prompt, and a list of action items.
public struct TextFieldView: View {
    
    @Binding var model: TextFieldViewModel
    private let items: [TextFieldViewItem]
    
    private let delegate = Delegate()
    
    /// Create the view without items.
    public init(model: Binding<TextFieldViewModel>) {
        _model = model
        self.items = []
    }
    
    /// Create the view with items.
    public init(model: Binding<TextFieldViewModel>, @TextFieldViewItemBuilder items: @escaping () -> [TextFieldViewItem] ) {
        _model = model
        self.items = items()
    }
    
    public var body: some View {
        VStack(spacing: 40) {
            HeaderView(header: $model.header, delegate: delegate)
            TextFieldWrapper(model: $model, delegate: delegate)
            Render(if: !model.prompt.text.isEmpty) {
                PromptView(prompt: $model.prompt)
            }
            ItemGridView(items: items).padding(.horizontal, -20)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
    }
}


// MARK: HeaderView

extension TextFieldView {
    
    struct HeaderView: View {
        @Binding var header: TextFieldViewModel.Header
        let delegate: Delegate
        var body: some View {
            HStack {
                Text(LocalizedStringKey(header.title))
                    .font(.title3.weight(.bold))
                Spacer()
                Button(LocalizedStringKey(header.cancel), action: delegate.onCancel ?? {})
                    .font(.body)
            }
        }
    }
}


// MARK: TextField

extension TextFieldView {
    
    struct TextFieldWrapper: View {
        @Binding var model: TextFieldViewModel
        let delegate: Delegate
        @State private var components = Components()
        private var textField: UITextField { components.textField }
        var body: some View {
            VStack(spacing: 16) {
                UIViewWrapper(onMake: makeTextField)
                    .fixedSize(horizontal: false, vertical: true)
                Rectangle()
                    .fill(model.field.divider ?? Color(.opaqueSeparator))
                    .frame(height: 0.5)
            }
            .onAppear(perform: setup)
            .onChange(of: model.field, perform: updateTextField)
            .onReceive(model.action, perform: handleAction)
        }
        
        private func setup() {
            updateTextField(with: model.field)
        }
        
        private func makeTextField() -> UITextField {
            textField.setContentHuggingPriority(.required, for: .vertical)
            textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            textField.adjustsFontForContentSizeCategory = true
            textField.font = .init(style: .title1)
            textField.onReceive(.editingChanged, perform: handleTextChanged)
            textField.onReceive(.editingDidEndOnExit, perform: handleReturnKey)
            if model.field.isInitiallyActive {
                textField.becomeFirstResponder()
            }
            return textField
        }
        
        private func updateTextField(with field: TextFieldViewModel.Field) {
            if textField.text != field.text {
                textField.text = field.text
            }
            textField.placeholder = field.placeholder
            textField.keyboardType = field.keyboard
            textField.returnKeyType = field.returnKey
            textField.clearButtonMode = field.clearButtonMode
            textField.isSecureTextEntry = field.isSecureEntry
            textField.autocorrectionType = field.autocorrection
            textField.autocapitalizationType = field.autocapitalization
            textField.spellCheckingType = field.spellChecking
            textField.textContentType = field.textContent
        }
        
        private func handleTextChanged() {
            let text = textField.text ?? ""
            if let replacement = delegate.onTextWillChange {
                let replacement = replacement(text)
                textField.text = replacement
                model.field.text = replacement
            } else {
                model.field.text = text
            }
        }
        
        private func handleReturnKey() {
            delegate.onCommit?()
        }
        
        private func handleAction(_ request: TextFieldViewModel.Action) {
            switch request {
            case .shakeTextField: shakeTextField()
            }
        }
        
        private func shakeTextField() {
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            let values = [1, -3, -6, -3, 1, 3, 6, 3, 1]
            animation.values = values
            animation.duration = 0.25
            animation.repeatCount = 2
            textField.layer.add(animation, forKey: nil)

            let feedback = UINotificationFeedbackGenerator()
            feedback.notificationOccurred(.error)
        }
        
        struct Components {
            let textField = UITextField()
        }
    }
}


// MARK: PromptView

extension TextFieldView {
    
    struct PromptView: View {
        @Binding var prompt: TextFieldViewModel.Prompt
        var body: some View {
            Text(LocalizedStringKey(prompt.text))
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.footnote)
                .foregroundColor(prompt.color ?? Color(.secondaryLabel))
        }
    }
}


// MARK: - ItemGridView

extension TextFieldView {
    
    struct ItemGridView: View {
        let items: [TextFieldViewItem]
        private let rows = [GridItem(.flexible(minimum: 10))]
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows, alignment: .top, spacing: 12) {
                    ForEach(items, id: \.id) { item in
                        switch item {
                        case is TextFieldViewButtonItem:
                            TextFieldView.ButtonItemView(item: item as! TextFieldViewButtonItem)
                        default: EmptyView()
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .animation(.spring())
            }
        }
    }
}


// MARK: - ButtonItemView

extension TextFieldView {
    
    struct ButtonItemView: View {
        
        let item: TextFieldViewButtonItem
        
        @State private var scale: CGFloat = 1
        
        var foreground: Color { item.foreground ?? .accentColor }
        var background: Color { item.background ?? foreground.opacity(0.1) }
        
        var body: some View {
            ZStack {
                Text(" ").hidden()
                HStack(spacing: 8) {
                    item.icon
                    Render(if: !item.text.isEmpty) {
                        Text(LocalizedStringKey(item.text))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .foregroundColor(foreground)
            .background(background.cornerRadius(9))
            .font(.body)
            .scaleEffect(scale, anchor: .center)
            .onTapGesture(perform: handleTapGesture)
        }
        
        private func handleTapGesture() {
            animateTap()
            item.action()
        }
        
        private func animateTap() {
            let animation = Animation.spring()
            $scale.animation(animation).wrappedValue = 0.9
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                $scale.animation(animation).wrappedValue = 1
            }
        }
    }
}


// MARK: Delegate

extension TextFieldView {
    
    class Delegate {
        var onCommit: (() -> Void)?
        var onCancel: (() -> Void)?
        var onTextWillChange: ((String) -> String)?
    }
    
    /// An action to perform on commit.
    public func onCommit(perform action: @escaping () -> Void) -> Self {
        delegate.onCommit = action
        return self
    }
    
    /// An action to perform on cancel.
    public func onCancel(perform action: @escaping () -> Void) -> Self {
        delegate.onCancel = action
        return self
    }
    
    /// Implement this method to replace the current text.
    ///
    /// This is a good place to do text formatting.
    public func onTextWillChange(perform action: @escaping (String) -> String) -> Self {
        delegate.onTextWillChange = action
        return self
    }
}


// MARK: - Preview

struct TextFieldView_Previews: PreviewProvider {
    struct PreviewContent: View {
        @State private var model = TextFieldViewModel()
        @State private var deleted = false
        @State private var buttonTapCount = 0
        var securedIcon: String { model.field.isSecureEntry ? "eye" : "eye.slash" }
        var body: some View {
            TextFieldView(model: $model) {
                TextFieldViewButtonItem(id: "shake", text: "Shake") {
                    model.sendAction(.shakeTextField)
                }
                TextFieldViewButtonItem(id: "secured", icon: securedIcon) {
                    $model.field.isSecureEntry.animation().wrappedValue.toggle()
                }
                if deleted {
                    TextFieldViewButtonItem(id: "undo", text: "Undo") {
                        deleted = false
                    }
                } else {
                    TextFieldViewButtonItem(id: "delete", text: "Delete", icon: "trash") {
                        deleted = true
                    }
                    .foreground(.red)
                    .background(.red.opacity(0.1))
                }
                TextFieldViewButtonItem(id: "label", text: "Label", action: {})
                    .foreground(.secondary)
            }
            .onTextWillChange { text in
                "~\(text.replacingOccurrences(of: "~", with: ""))"
            }
            .onCommit {
                model.header.title = model.field.text
            }
            .onAppear {
                model.header.title = "TextFieldView V2"
                model.field.text = "Secured"
                model.field.isInitiallyActive = true
            }
        }
    }
    static let model = TextFieldViewModel()
    static var previews: some View {
        PreviewContent()
            .preferredColorScheme(.dark)
        
        PreviewContent()
    }
}
