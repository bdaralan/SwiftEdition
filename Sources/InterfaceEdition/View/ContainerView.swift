import SwiftUI


/// A container view that supports alignment and padding.
final public class ContainerView<Content>: UIView where Content: UIView {
    
    /// The content view.
    public var content: Content? {
        didSet { setContent(content) }
    }
    
    /// The `content`'s container.
    public var contentContainer: UIView { container }
    
    /// The padding of `content` within the `contentContainer`.
    public var padding: NSDirectionalEdgeInsets {
        get { container.padding }
        set { container.padding = newValue }
    }
    
    /// The alignment of the `content`.
    public var alignment: Alignment {
        didSet { setContentAlignment(alignment) }
    }
    
    private let container = UIStackView()
    private let verticalContainer = UIStackView(.vertical)
    private let horizontalContainer = UIStackView(.horizontal)
    
    public init(alignment: Alignment = .center, content: Content? = nil) {
        self.alignment = alignment
        self.content = content
        super.init(frame: .zero)
        setup()
        setContent(content)
        setContentAlignment(alignment)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setContent(_ content: Content?) {
        if let content = content {
            guard container.arrangedSubviews.contains(content) == false else { return }
            container.setArrangedSubviews(content)
        } else {
            container.removeArrangedSubviews()
        }
    }
    
    private func setContentAlignment(_ alignment: Alignment) {
        let containerAlignments = alignment.containerAlignments
        verticalContainer.alignment = containerAlignments.horizontal
        horizontalContainer.alignment = containerAlignments.vertical
    }
    
    private func setup() {
        horizontalContainer.setArrangedSubviews(container)
        verticalContainer.setArrangedSubviews(horizontalContainer)
        addAutoLayoutSubview(verticalContainer)
        verticalContainer.constraint(fill: self)
    }
}


extension ContainerView {
    
    public enum Alignment {
        case center
        case top
        case bottom
        case leading
        case trailing
        case topLeading
        case topTrailing
        case bottomLeading
        case bottomTrailing
        case fill
        case fillVertically
        case fillHorizontally
        case fillVerticallyLeading
        case fillVerticallyTrailing
        case fillHorizontallyTop
        case fillHorizontallyBottom
        
        fileprivate var containerAlignments: (vertical: UIStackView.Alignment, horizontal: UIStackView.Alignment) {
            switch self {
            case .center: return (.center, .center)
            case .top: return (.top, .center)
            case .bottom: return (.bottom, .center)
            case .leading: return (.center, .leading)
            case .trailing: return (.center, .trailing)
            case .topLeading: return (.top, .leading)
            case .topTrailing: return (.top, .trailing)
            case .bottomLeading: return (.bottom, .leading)
            case .bottomTrailing: return (.bottom, .trailing)
            case .fill: return (.fill, .fill)
            case .fillVertically: return (.fill, .center)
            case .fillHorizontally: return (.center, .fill)
            case .fillVerticallyLeading: return (.fill, .leading)
            case .fillVerticallyTrailing: return (.fill, .trailing)
            case .fillHorizontallyTop: return (.top, .fill)
            case .fillHorizontallyBottom: return (.bottom, .fill)
            }
        }
    }
}


struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerWrapper {
            let controller = UIViewController()
            let label = UILabel(text: "Label")
            label.backgroundColor = .red
            
            let container = ContainerView(alignment: .center, content: label)
            container.contentContainer.backgroundColor = .systemFill
            container.padding = .init(vertical: 10, horizontal: 20)
            
            controller.view.addAutoLayoutSubview(container)
            container.constraint(fill: controller.view)
            return controller
        }
    }
}
