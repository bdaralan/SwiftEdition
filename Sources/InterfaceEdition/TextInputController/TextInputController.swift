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
    
    private let itemCollection = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private var itemDataSource: ItemDataSource!
    
    private var bindings: Set<AnyCancellable> = []
    
    public init(model: TextInputModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupItemDataSource()
        setupTextFieldActions()
        setupCancelButtonActions()
        setupBindings()
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
        
        model.$items.sink(weak: self, storeIn: &bindings) { this, items in
            this.update(with: items)
        }
        
        model.$action.sink(weak: self, storeIn: &bindings) { this, action in
            this.handleAction(action)
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
        
        textField.onReceived(.editingChanged, perform: textChangedAction)
        textField.onReceived(.editingDidEndOnExit, perform: returnKeyAction)
    
        if model.field.initiallyActive {
            textField.becomeFirstResponder()
        }
    }
    
    private func setupCancelButtonActions() {
        let cancel = Action.weak(self) { this in
            this.model.handler.onCancel?()
        }
        
        cancelButton.onReceived(.touchUpInside, perform: cancel)
    }
    
    private func setupItemDataSource() {
        itemDataSource = .init(collectionView: itemCollection) { collection, indexPath, item in
            switch item {
            case let .tag(item):
                let cell = collection.dequeueCell(TagItemCell.self, for: indexPath)
                cell.update(with: item)
                return cell
            }
        }
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
                
        itemCollection.delegate = self
        itemCollection.collectionViewLayout = makeItemCollectionLayout()
        itemCollection.alwaysBounceVertical = false
        itemCollection.alwaysBounceHorizontal = true
        itemCollection.backgroundColor = .clear
        itemCollection.registerCell(TagItemCell.self)
        
        let titleView = UIStackView(.horizontal, spacing: 8)
        titleView.setArrangedSubviews(titleLabel, cancelButton)
        titleView.padding = .init(horizontal: 20)
        titleView.alignment = .firstBaseline
        
        let fieldView = UIStackView(.vertical, spacing: 16)
        fieldView.setArrangedSubviews(textField, divider)
        fieldView.padding = .init(horizontal: 20)
        
        let promptView = UIStackView(.vertical, views: promptLabel)
        promptView.padding = .init(horizontal: 20)
        
        let content = UIStackView(.vertical, spacing: 32)
        content.setArrangedSubviews(titleView, fieldView, promptView, itemCollection)
        content.padding.top = 24
        
        view.addSubview(content, useAutoLayout: true)
        content.constraint(fill: view)
        
        divider.heightAnchor.constraint(equalToConstant: 0.4).activate()

        cancelButton.setContentHuggingPriority(.required, for: .horizontal)
        
        itemCollection.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).activate()
    }
    
    private func makeItemCollectionLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .estimated(50))
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


// MARK: - Item Delegate

extension TextInputController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = itemDataSource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case let .tag(item): handleDidSelectTagItem(item)
        }
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
        divider.backgroundColor = field.divider ?? .opaqueSeparator
    }
    
    private func update(with prompt: TextInputModel.Prompt) {
        let text = prompt.text.localized
        let color = prompt.color ?? .secondaryLabel
        promptLabel.text = text
        promptLabel.textColor = color
        promptLabel.superview?.isHidden = text.isEmpty
    }
    
    private func update(with items: [TextInputItem]) {
        var snapshot = ItemDataSourceSnapshot()
        let dataItems = items.compactMap(ItemDataSourceItem.init)
        snapshot.appendSections([0])
        snapshot.appendItems(dataItems, toSection: 0)
        itemDataSource.apply(snapshot)
    }
    
    private func handleDidSelectTagItem(_ item: TextInputTagItem) {
        guard let action = item.action else { return }
        guard let indexPath = itemDataSource.indexPath(for: .tag(item)) else { return }
        guard let cell = itemCollection.cellForItem(at: indexPath) else { return }
        let control = UIControl(frame: .zero, primaryAction: action)
        
        animateCellSelection(cell)
        control.sendAction(action)
    }
    
    private func handleAction(_ action: TextInputModel.Action?) {
        switch action {
        case .none: break
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


// MARK: - Item DataSource

extension TextInputController {
    
    private typealias ItemDataSource = UICollectionViewDiffableDataSource<Int, ItemDataSourceItem>
    private typealias ItemDataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, ItemDataSourceItem>
    
    private enum ItemDataSourceItem: Hashable {
        case tag(TextInputTagItem)
        
        init?(item: TextInputItem) {
            if let item = item as? TextInputTagItem {
                self = .tag(item)
                return
            }
            return nil
        }
    }
}


// MARK: - Preview

struct TextInputViewController_Previews: PreviewProvider {
    static let model = TextInputModel()
    static var previews: some View {
        UIViewControllerWrapper {
            model.header.title = "Text Input"
            model.field.placeholder = "Placeholder"
            model.prompt.text = "Prompt"
            
            let delete = Action.weak(model) { model in
                model.items.remove(at: 0)
            }
            let image = UIImage(systemName: "trash")
            let tag1 = TextInputTagItem(text: "Delete", image: image, foreground: .systemRed, background: UIColor.systemRed.withAlphaComponent(0.1), action: delete)
            
            let tag2 = TextInputTagItem(text: "No Action")
            
            let animate = Action.weak(model) { model in
                model.sendAction(.shakeTextField)
            }
            let tag3 = TextInputTagItem(text: "Shake", action: animate)

            model.items = [tag1, tag2, tag3]
            
            let controller = TextInputController(model: model)
            return controller
        }
    }
}
