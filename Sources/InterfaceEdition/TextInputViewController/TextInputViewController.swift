import SwiftUI
import Combine
import CombineEdition
import UtilityEdition


public final class TextInputViewController: UIViewController {
    
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
            this.model.actions.onCommit?()
        }
        
        textField.addAction(textChangedAction, for: .editingChanged)
        textField.addAction(returnKeyAction, for: .editingDidEndOnExit)
    
        if model.field.initiallyActive {
            textField.becomeFirstResponder()
        }
    }
    
    private func setupCancelButtonActions() {
        let cancel = Action.weak(self) { this in
            this.model.actions.onCancel?()
        }
        
        cancelButton.addAction(cancel, for: .touchUpInside)
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

extension TextInputViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = itemDataSource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case let .tag(item):
            let cell = collectionView.cellForItem(at: indexPath) as! TagItemCell
            cell.animateSelection()
            item.performAction()
        }
    }
}


// MARK: - Item DataSource

extension TextInputViewController {
    
    private typealias ItemDataSource = UICollectionViewDiffableDataSource<Int, ItemDataSourceItem>
    private typealias ItemDataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, ItemDataSourceItem>
    
    private enum ItemDataSourceItem: Hashable {
        case tag(TextInputModel.TagItem)
        
        init?(item: TextInputItem) {
            switch item {
            case is TextInputModel.TagItem: self = .tag(item as! TextInputModel.TagItem)
            default: return nil
            }
        }
    }
}


// MARK: - Preview

struct TextInputViewController_Previews: PreviewProvider {
    static let model = TextInputModel()
    static var previews: some View {
        Color(.systemBackground).sheet(isPresented: .constant(true)) {
            UIViewControllerWrapper {
                model.header.title = "Text Input"
                model.field.placeholder = "Placeholder"
                model.prompt.text = "Prompt"
                
                let deleteTag1 = Action.weak(model) { model in
                    model.items.remove(at: 0)
                }

                let tag1 = TextInputModel.TagItem(text: "Tag 1", action: deleteTag1)
                let tag2 = TextInputModel.TagItem(text: "Tag 2")

                model.items = [tag1, tag2]
                
                return TextInputViewController(model: model)
            }
            .preferredColorScheme(.dark)
        }
    }
}
