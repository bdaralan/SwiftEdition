import SwiftUI
import AutoLayoutEdition


public struct TextFieldView: View {
    
    @ObservedObject var model: TextFieldModel
    
    public init(model: TextFieldModel) {
        self.model = model
    }
    
    public var body: some View {
        VStack(spacing: 40) {
            HeaderView()
            TextField()
            Render(if: !model.prompt.text.isEmpty) {
                PromptView()
            }
            ItemGridView().padding(.horizontal, -20)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .environmentObject(model)
    }
}


extension TextFieldView.TextField {
    
    struct Components {
        let textField = UITextField()
    }
}


extension TextFieldView {
    
    struct HeaderView: View {
        @EnvironmentObject private var model: TextFieldModel
        private var header: TextFieldModel.Header { model.header }
        private var handler: TextFieldModel.Handler { model.handler }
        var body: some View {
            HStack {
                Text(LocalizedStringKey(header.title))
                    .font(Font.title3.weight(.bold))
                Spacer()
                Button(LocalizedStringKey(header.cancel), action: handler.onCancel ?? {})
                    .font(.body)
            }
        }
    }
}


extension TextFieldView {
    
    struct TextField: View {
        @EnvironmentObject private var model: TextFieldModel
        private var field: TextFieldModel.Field { model.field }
        private var handler: TextFieldModel.Handler { model.handler }
        @State private var components = Components()
        var body: some View {
            VStack(spacing: 16) {
                UIViewWrapper(onMake: makeTextField)
                Rectangle()
                    .fill(Color(model.field.divider ?? .opaqueSeparator))
                    .frame(height: 0.5)
            }
            .onReceive(model.$field, perform: update)
            .onReceive(model.action.publisher, perform: handleAction)
        }
        
        private func makeTextField() -> UITextField {
            let textField = components.textField
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
        
        private func update(with field: TextFieldModel.Field) {
            let textField = components.textField
            if textField.text != field.text {
                textField.text = field.text
            }
            textField.placeholder = field.placeholder
            textField.keyboardType = field.keyboard
            textField.returnKeyType = field.returnKey
            textField.clearButtonMode = field.clearButtonMode
            textField.isSecureTextEntry = field.isSecureEntry
        }
        
        private func handleTextChanged() {
            let textField = components.textField
            if let formattedText = model.handler.onTextChange {
                let text = formattedText(textField.text!)
                textField.text = text
                model.field.text = text
            } else {
                model.field.text = textField.text!
            }
        }
        
        private func handleReturnKey() {
            model.handler.onCommit?()
        }
        
        private func handleAction(_ actionType: TextFieldModel.Action.ActionType) {
            switch actionType {
            case .shakeTextField: shakeTextField()
            }
        }
        
        private func shakeTextField() {
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.duration = 0.25
            animation.values = [1, -3, -6, -3, 1, 3, 6, 3, 1]
            animation.repeatCount = 2
            components.textField.layer.add(animation, forKey: nil)
            
            let feedback = UINotificationFeedbackGenerator()
            feedback.notificationOccurred(.error)
        }
    }
}


extension TextFieldView {
    
    struct PromptView: View {
        @EnvironmentObject private var model: TextFieldModel
        private var prompt: TextFieldModel.Prompt { model.prompt }
        var body: some View {
            Text(LocalizedStringKey(prompt.text))
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.footnote)
                .foregroundColor(Color(prompt.color ?? .secondaryLabel))
        }
    }
}


public class TextFieldViewController: UIViewController {
    
    public let model: TextFieldModel
    
    private let content: UIHostingController<TextFieldView>
    
    public init(model: TextFieldModel) {
        self.model = model
        content = .init(rootView: .init(model: model))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addChild(content)
        view.addSubview(content.view)
        content.view.anchor.pinTo(view)
        content.didMove(toParent: self)
    }
}


struct TextFieldView_Previews: PreviewProvider {
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
        
        let shake = TextFieldTagItem(text: "Shake") { item in
            model.action.perform(.shakeTextField)
        }
        
        var secure = TextFieldToggleItem(active: false) { item in
            model.field.isSecureEntry = item.active
        }
        secure.images.active = UIImage(systemName: "eye")
        secure.images.inactive = UIImage(systemName: "eye.slash")
        secure.backgrounds.active = UIColor.systemRed.withAlphaComponent(0.1)
        secure.backgrounds.inactive = UIColor.systemGreen.withAlphaComponent(0.1)

        model.item.items = [delete, noAction, shake, secure]
        return model
    }()
    static var previews: some View {
        TextFieldView(model: model)
    }
}
