import SwiftUI


/// A container view that supports alignment and padding.
final public class ViewContainer: UIView {
    
    /// The content view.
    public var content: UIView? {
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
    
    public init(alignment: Alignment = .center, content: UIView? = nil) {
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
    
    private func setContent(_ content: UIView?) {
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


extension ViewContainer {
    
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
    static let alignments1: [ViewContainer.Alignment] = [
        .center, .top, .bottom, .leading, .trailing,
        .topLeading, .topTrailing,
        .bottomLeading, .bottomTrailing
    ]
    static let alignments2: [ViewContainer.Alignment] = [
        .fill, .fillVertically, .fillHorizontally,
        .fillVerticallyLeading, .fillVerticallyTrailing,
        .fillHorizontallyTop, .fillHorizontallyBottom
    ]
    static var previews: some View {
        ForEach(alignments1, id: \.self) { alignment in
            UIViewControllerWrapper {
                let controller = UIViewController()
                let label = UILabel(text: "\(alignment)")
                label.backgroundColor = .systemFill
                
                let container = ViewContainer(alignment: alignment, content: label)
                container.contentContainer.backgroundColor = .secondarySystemBackground
                container.padding = .init(vertical: 10, horizontal: 20)
                
                controller.view.addAutoLayoutSubview(container)
                container.constraint(fill: controller.view)
                return controller
            }
        }
    }
}
