import SwiftUI


/// A container view that supports alignment and padding.
final public class ViewContainer: UIView {
    
    /// The view that the container will manage.
    public var view: UIView? {
        didSet { setView(view) }
    }
    
    /// The container view used to layout the `view`.
    public var contentView: UIView { viewContainer }
    
    /// The alignment of the `view`.
    public var alignment: Alignment {
        didSet { setViewAlignment(alignment) }
    }
    
    /// The padding of `view` within the `contentView`.
    public var padding: NSDirectionalEdgeInsets {
        get { viewContainer.padding }
        set { viewContainer.padding = newValue }
    }
    
    private let viewContainer = UIStackView()
    private let verticalContainer = UIStackView(.vertical)
    private let horizontalContainer = UIStackView(.horizontal)
    
    public init(alignment: Alignment = .center, view: UIView? = nil) {
        self.alignment = alignment
        self.view = view
        super.init(frame: .zero)
        setup()
        setView(view)
        setViewAlignment(alignment)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(_ view: UIView?) {
        if let view = view {
            guard viewContainer.arrangedSubviews.contains(view) == false else { return }
            viewContainer.setArrangedSubviews(view)
        } else {
            viewContainer.removeArrangedSubviews()
        }
    }
    
    private func setViewAlignment(_ alignment: Alignment) {
        let alignments = alignment.viewAlignments
        verticalContainer.alignment = alignments.horizontal
        horizontalContainer.alignment = alignments.vertical
    }
    
    private func setup() {
        horizontalContainer.setArrangedSubviews(viewContainer)
        verticalContainer.setArrangedSubviews(horizontalContainer)
        addSubview(verticalContainer)
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
        
        fileprivate var viewAlignments: (vertical: UIStackView.Alignment, horizontal: UIStackView.Alignment) {
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
                
                let container = ViewContainer(alignment: alignment, view: label)
                container.contentView.backgroundColor = .secondarySystemBackground
                container.padding = .init(vertical: 10, horizontal: 20)
                
                controller.view.addSubview(container)
                container.constraint(fill: controller.view)
                return controller
            }
        }
    }
}
