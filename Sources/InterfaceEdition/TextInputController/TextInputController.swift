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
    private var itemBindings: [String: AnyCancellable] = [:]
    
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
    
    private func setupItemDataSource() {
        itemDataSource = .init(collectionView: itemCollection) { [weak self] collection, indexPath, item in
            guard let self = self else { return nil }
            switch item {
            case let .tag(item):
                let cell = collection.dequeueCell(TagItemCell.self, for: indexPath)
                cell.update(with: item)
                self.setupCellBinding(for: item, at: indexPath)
                return cell
                
            case let .toggle(item):
                let cell = collection.dequeueCell(ToggleItemCell.self, for: indexPath)
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
        itemCollection.alwaysBounceHorizontal = false
        itemCollection.backgroundColor = .clear
        itemCollection.registerCell(TagItemCell.self)
        itemCollection.registerCell(ToggleItemCell.self)
        
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
        content.setArrangedSubviews(titleView, fieldView, promptView, itemCollection)
        content.padding.top = 24
        
        view.addAutoLayoutSubview(content)
        content.constraint(fill: view)
        
        divider.heightAnchor.constraint(equalToConstant: 0.4).activate()
        
        itemCollection.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).activate()
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


// MARK: - Item Delegate

extension TextInputController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = itemDataSource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case let .tag(tag):
            guard let action = tag.action else { return }
            guard let cell = collectionView.cellForItem(at: indexPath) else { return }
            animateCellSelection(cell)
            action(tag)
            
        case let .toggle(toggle):
            guard let cell = collectionView.cellForItem(at: indexPath) as? ToggleItemCell else { return }
            animateCellSelection(cell)
            toggle.active.toggle()
            
            cell.update(with: toggle)
            update(with: model.items) {
                toggle.action(toggle)
            }
        }
    }
    
    private func handleDidSelectTagItem(_ tag: TextInputTagItem, at indexPath: IndexPath) {
        guard let action = tag.action else { return }
        guard let cell = itemCollection.cellForItem(at: indexPath) else { return }
        animateCellSelection(cell)
        action(tag)
    }
    
    private func handleDidSelectToggleItem(_ toggle: TextInputToggleItem, at indexPath: IndexPath) {
        guard let cell = itemCollection.cellForItem(at: indexPath) as? ToggleItemCell else { return }
        animateCellSelection(cell)
        toggle.active.toggle()
        
        cell.update(with: toggle)
        update(with: model.items) {
            toggle.action(toggle)
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
    
    private func update(with items: [TextInputItem], completion: (() -> Void)? = nil) {
        itemBindings.removeAll()
        
        var snapshot = ItemDataSourceSnapshot()
        let dataItems = items.compactMap(ItemDataSourceItem.init)
        snapshot.appendSections([0])
        snapshot.appendItems(dataItems, toSection: 0)
        itemDataSource.apply(snapshot, animatingDifferences: true, completion: completion)
    }
    
    private func setupCellBinding(for item: TextInputTagItem, at indexPath: IndexPath) {
        let key: (String) -> String = { item.id.appending($0) }
        
        item.$text.dropFirst().sink(weak: self, storeIn: &itemBindings, key: key("text")) { this, text in
            let cell = this.itemCollection.cellForItem(at: indexPath) as? TagItemCell
            cell?.update(text: text)
        }
        
        item.$image.dropFirst().sink(weak: self, storeIn: &itemBindings, key: key("image")) { this, image in
            let cell = this.itemCollection.cellForItem(at: indexPath) as? TagItemCell
            cell?.update(image: image)
        }
        
        item.$foreground.dropFirst().sink(weak: self, storeIn: &itemBindings, key: key("foreground")) { this, foreground in
            let cell = this.itemCollection.cellForItem(at: indexPath) as? TagItemCell
            cell?.update(foreground: foreground)
        }
        
        item.$background.dropFirst().sink(weak: self, storeIn: &itemBindings, key: key("background")) { this, background in
            let cell = this.itemCollection.cellForItem(at: indexPath) as? TagItemCell
            cell?.update(background: background)
        }
    }
    
//    func setupCellBinding(for item: TextInputToggleItem, at indexPath: IndexPath) {
//        let key: (String) -> String = { item.id.appending($0) }
//
//        item.$active.dropFirst().sink(weak: self, storeIn: &itemBindings, key: key("active")) { this, active in
//            guard let cell = this.itemCollection.cellForItem(at: indexPath) as? ToggleItemCell else { return }
//            cell.update(active: active)
//            this.update(with: this.model.items)
//
////            let toggleItem = this.itemDataSource.itemIdentifier(for: indexPath)!
////            var snapshot = ItemDataSourceSnapshot()
////            snapshot.reloadItems([toggleItem])
////            this.itemDataSource.apply(snapshot, animatingDifferences: true)
//
//        }
//    }
    
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
        case toggle(TextInputToggleItem)
        
        init?(item: TextInputItem) {
            if let item = item as? TextInputTagItem {
                self = .tag(item)
                return
            }
            if let item = item as? TextInputToggleItem {
                self = .toggle(item)
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
            model.field.text = "Password"
            model.field.placeholder = "Placeholder"
            model.prompt.text = "Prompt"
            
            let delete = TextInputTagItem(text: "Delete") { item in
                model.items.removeAll(where: { $0.id == item.id })
            }
            delete.image = UIImage(systemName: "trash")
            delete.foreground = .systemRed
            delete.background = delete.foreground?.withAlphaComponent(0.1)
            
            let noAction = TextInputTagItem(text: "No Action")
            
            let shake = TextInputTagItem(text: "Shake") { item in
                model.sendAction(.shakeTextField)
            }
            
            let toggleSecureField = TextInputTagItem(text: "") { item in
                model.field.isSecureEntry.toggle()
                item.image = UIImage(systemName: model.field.isSecureEntry ? "eye" : "eye.slash")
                item.background = model.field.isSecureEntry ? .systemGreen : .systemRed
                item.background = item.background?.withAlphaComponent(0.1)
            }
            toggleSecureField.background = UIColor.systemRed.withAlphaComponent(0.1)
            toggleSecureField.image = UIImage(systemName: "eye.slash")
            
            let toggle = TextInputToggleItem(active: true) { item in
            }
            toggle.text.active = "Active"
            toggle.text.inactive = "Inactive"
            toggle.image.active = UIImage(systemName: "circle.fill")
            toggle.image.inactive = UIImage(systemName: "circle")

            model.items = [delete, noAction, shake, toggleSecureField, toggle]
            
            let controller = TextInputController(model: model)
            controller.view.backgroundColor = .systemGroupedBackground
            return controller
        }
        .ignoresSafeArea()
    }
}
