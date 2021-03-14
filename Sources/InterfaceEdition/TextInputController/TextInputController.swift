import SwiftUI
import Combine
import CombineEdition
import UtilityEdition


public final class TextInputController: UIViewController {
    
    let model: TextInputModel
    
    private let titleLabel = UILabel()
    private let cancelButton = UIButton(type: .system)
    
    private let textField = UITextField()
    private let divider = UIView()
    
    private let promptLabel = UILabel()
    
    private let itemController: UIHostingController<TextInputItemView>
    
    private var bindings: Set<AnyCancellable> = []
    
    public init(model: TextInputModel) {
        self.model = model
        self.itemController = .init(rootView: .init(model: model))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addChild(itemController)
        setup()
        setupTextFieldActions()
        setupCancelButtonActions()
        setupBindings()
        itemController.didMove(toParent: self)
    }
    
    private func setupBindings() {
        bindings.removeAll()
        
        model.$header.sink(weak: self, storeIn: &bindings) { this, header in
            this.update(with: header)
        }
        
        model.$field.sink(weak: self, storeIn: &bindings) { this, field in
            this.update(with: field)
        }
        
        model.$prompt.sink(weak: self, storeIn: &bindings) { this, prompt in
            this.update(with: prompt)
        }
        
        model.action.publisher.sink(weak: self, storeIn: &bindings) { this, actionType in
            this.handleAction(type: actionType)
        }
    }
    
    private func setupTextFieldActions() {
        let textChangedAction = Action.weak(self) { this in
            if let formatter = this.model.field.formatter {
                let text = formatter(this.textField.text!)
                this.textField.text = text
                this.model.field.text = text
            } else {
                this.model.field.text = this.textField.text!
            }
        }
        
        let returnKeyAction = Action.weak(self) { this in
            this.model.handler.onCommit?()
        }
        
        textField.onReceive(.editingChanged, perform: textChangedAction)
        textField.onReceive(.editingDidEndOnExit, perform: returnKeyAction)
    
        if model.field.isInitiallyActive {
            textField.becomeFirstResponder()
        }
    }
    
    private func setupCancelButtonActions() {
        let cancel = Action.weak(self) { this in
            this.model.handler.onCancel?()
        }
        
        cancelButton.onReceive(.touchUpInside, perform: cancel)
    }
    
    private func setup() {
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.font = .init(style: .title2, traits: .traitBold)
        titleLabel.numberOfLines = 2
        
        textField.adjustsFontForContentSizeCategory = true
        textField.font = .init(style: .title1)
        textField.clearButtonMode = .whileEditing
        
        promptLabel.adjustsFontForContentSizeCategory = true
        promptLabel.font = .init(style: .footnote)
        promptLabel.numberOfLines = 0
        
        let itemListView = itemController.view!
        itemListView.backgroundColor = .clear
        
        let titleView = UIStackView(.horizontal, spacing: 8)
        titleView.setArrangedSubviews(titleLabel, cancelButton)
        titleView.padding = .init(horizontal: 20)
        titleView.alignment = .firstBaseline
        titleView.distribution = .equalCentering
        
        let fieldView = UIStackView(.vertical, spacing: 16)
        fieldView.setArrangedSubviews(textField, divider)
        fieldView.padding = .init(horizontal: 20)
        
        let promptView = UIStackView(.vertical, views: promptLabel)
        promptView.padding = .init(horizontal: 20)
        
        let content = UIStackView(.vertical, spacing: 32)
        content.setArrangedSubviews(titleView, fieldView, promptView, itemListView, UIView())
        content.padding.top = 24
        
        view.addAutoLayoutSubview(content)
        content.constraint(fill: view)
        
        divider.heightAnchor.constraint(equalToConstant: 0.4).activate()
    }
    
    private func makeItemCollectionLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(400), heightDimension: .estimated(75))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(400), heightDimension: .estimated(75))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 12
        section.contentInsets = .init(horizontal: 20)
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .vertical
        
        return .init(section: section, configuration: configuration)
    }
}


// MARK: - Handler

extension TextInputController {
    
    private func update(with header: TextInputModel.Header) {
        let title = header.title.localized
        let cancel = header.cancel.localized
        titleLabel.text = title
        cancelButton.setTitle(cancel, for: .normal)
    }
    
    private func update(with field: TextInputModel.Field) {
        if textField.text != field.text {
            textField.text = field.text
        }
        textField.placeholder = field.placeholder.localized
        textField.keyboardType = field.keyboard
        textField.returnKeyType = field.returnKey
        textField.isSecureTextEntry = field.isSecureEntry
        divider.backgroundColor = field.divider ?? .opaqueSeparator
    }
    
    private func update(with prompt: TextInputModel.Prompt) {
        let text = prompt.text.localized
        let color = prompt.color ?? .secondaryLabel
        promptLabel.text = text
        promptLabel.textColor = color
        promptLabel.superview?.isHidden = text.isEmpty
    }
    
    private func handleAction(type: TextInputModel.Action.ActionType) {
        switch type {
        case .shakeTextField: shakeTextField()
        }
    }
    
    private func shakeTextField() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.duration = 0.25
        animation.values = [1, -3, -6, -3, 1, 3, 6, 3, 1]
        animation.repeatCount = 2
        textField.layer.add(animation, forKey: nil)
        
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.error)
    }
    
    private func animateCellSelection(_ cell: UICollectionViewCell) {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.duration = 0.2
        animation.values = [1, 0.8, 1]
        cell.layer.add(animation, forKey: nil)
    }
}


// MARK: - Preview

struct TextInputViewController_Previews: PreviewProvider {
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
        
        let shake = TextInputTagItem(text: "Shake") { item in
            model.action.perform(.shakeTextField)
        }
        
        var secure = TextInputToggleItem(active: false) { item in
            model.field.isSecureEntry = item.active
        }
        secure.imageValue.active = UIImage(systemName: "eye")
        secure.imageValue.inactive = UIImage(systemName: "eye.slash")
        secure.backgroundValue.active = UIColor.systemRed.withAlphaComponent(0.1)
        secure.backgroundValue.inactive = UIColor.systemGreen.withAlphaComponent(0.1)

        model.item.items = [delete, noAction, shake, secure]
        return model
    }()
    static var previews: some View {
        UIViewControllerWrapper {
            let controller = TextInputController(model: model)
            controller.view.backgroundColor = .systemGroupedBackground
            return controller
        }
        .ignoresSafeArea()
    }
}
