import SwiftUI


/// A container view that supports alignment and padding.
final public class ContainerView<Content>: UIView where Content: UIView {
    
    /// The content view.
    public var content: Content? {
        get { container.arrangedSubviews.first as? Content }
        set { setContent(newValue) }
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
        willSet { setContentAlignment(newValue) }
    }
    
    private let container = UIStackView()
    private let verticalContainer = UIStackView(.vertical)
    private let horizontalContainer = UIStackView(.horizontal)
    
    public enum Alignment {
        case top
        case bottom
        case leading
        case trailing
        case center
        case topLeading
        case topTrailing
        case bottomLeading
        case bottomTrailing
    }
    
    public init(alignment: Alignment = .center, content: Content? = nil) {
        self.alignment = alignment
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
            guard content !== self.content else { return }
            container.setArrangedSubviews(content)
        } else {
            container.removeArrangedSubviews()
        }
    }
    
    private func setContentAlignment(_ alignment: Alignment) {
        let alignments: (vertical: UIStackView.Alignment, horizontal: UIStackView.Alignment)
        switch alignment {
        case .top: alignments = (.top, .center)
        case .bottom: alignments = (.bottom, .center)
        case .leading: alignments = (.center, .leading)
        case .trailing: alignments = (.center, .trailing)
        case .center: alignments = (.center, .center)
        case .topLeading: alignments = (.top, .leading)
        case .topTrailing: alignments = (.top, .trailing)
        case .bottomLeading: alignments = (.bottom, .leading)
        case .bottomTrailing: alignments = (.bottom, .trailing)
        }
        verticalContainer.alignment = alignments.horizontal
        horizontalContainer.alignment = alignments.vertical
    }
    
    private func setup() {
        horizontalContainer.setArrangedSubviews(container)
        verticalContainer.setArrangedSubviews(horizontalContainer)
        addAutoLayoutSubview(verticalContainer)
        verticalContainer.constraint(fill: self)
    }
}


struct SwiftUIView_Previews: PreviewProvider {
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
