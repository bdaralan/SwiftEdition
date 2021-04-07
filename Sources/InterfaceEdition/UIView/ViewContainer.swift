import SwiftUI
import AutoLayoutEdition


/// A view container that utilizes stack views to render a view and supports alignment and padding.
///
/// By default, the container has an intrinsic content size of the view it manages.
///
final public class ViewContainer: UIView {
    
    /// The view that the container will manage.
    public var view: UIView? {
        didSet { setView(view) }
    }
    
    /// The container view used to layout the `view`.
    public var viewContainer: UIView { contentContainer }
    
    /// The alignment of the `view`.
    public var alignment: Alignment {
        didSet { setViewAlignment(alignment) }
    }
    
    /// The padding of `view` within the `viewContainer`.
    public var padding: NSDirectionalEdgeInsets {
        get { contentContainer.padding }
        set { contentContainer.padding = newValue }
    }
    
    /// The preferred intrinsic content size. The default is `UIView.layoutFittingCompressedSize`.
    public var preferredIntrinsicContentSize: CGSize = UIView.layoutFittingCompressedSize {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    private let contentContainer = UIStackView()
    private let verticalContainer = UIStackView(.vertical)
    private let horizontalContainer = UIStackView(.horizontal)
    
    public override var intrinsicContentSize: CGSize {
        preferredIntrinsicContentSize
    }
    
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
            guard contentContainer.arrangedSubviews.contains(view) == false else { return }
            contentContainer.setArrangedSubviews(view)
        } else {
            contentContainer.removeArrangedSubviews()
        }
    }
    
    private func setViewAlignment(_ alignment: Alignment) {
        let alignments = alignment.viewAlignments
        verticalContainer.alignment = alignments.horizontal
        horizontalContainer.alignment = alignments.vertical
    }
    
    private func setup() {
        horizontalContainer.setArrangedSubviews(contentContainer)
        verticalContainer.setArrangedSubviews(horizontalContainer)
        addSubview(verticalContainer)
        verticalContainer.anchor.pinTo(self)
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
                let label = UILabel()
                label.text = "\(alignment)"
                label.font = .monospacedSystemFont(ofSize: 17, weight: .bold)
                label.backgroundColor = .systemRed
                
                let container = ViewContainer(alignment: alignment, view: label)
                container.viewContainer.backgroundColor = .systemBlue
                container.padding = .init(vertical: 10, horizontal: 20)
                
                controller.view.addSubview(container)
                container.anchor.pinTo(controller.view)
                container.backgroundColor = .systemGreen
                return controller
            }
        }
        .overlay(
            VStack(alignment: .leading, spacing: 4) {
                Text("GREEN: ViewContainer")
                Text("BLUE : ViewContainer.viewContainer")
                Text("RED  : ViewContainer.view")
                
                Text("NOTE : BLUE here has some padding or it has the same bounds as RED")
                    .padding(.top)
                    .font(.system(.footnote, design: .monospaced))
            }
            .font(.system(.footnote, design: .monospaced))
            .padding(.horizontal)
            .offset(y: -100)
        )
    }
}
