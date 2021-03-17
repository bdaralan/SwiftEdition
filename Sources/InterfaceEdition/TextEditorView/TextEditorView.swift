import SwiftUI


public struct TextEditorView: View {
    
    let model: TextEditorModel
    
    public var body: some View {
        VStack(spacing: 20) {
            HeaderView()
            CounterDivider()
            TextView()
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .environmentObject(model)
    }
}


// MARK: - HeaderView

extension TextEditorView {
 
    struct HeaderView: View {
        @EnvironmentObject private var model: TextEditorModel
        private var header: TextEditorModel.Header { model.header }
        private var handler: TextEditorModel.Handler { model.handler }
        var body: some View {
            HStack {
                Text(LocalizedStringKey(header.title))
                    .font(Font.title3.weight(.bold))
                Spacer()
                HStack(spacing: 12) {
                    Button(LocalizedStringKey(header.cancel), action: handler.onCancel)
                        .font(.body)
                    Button(LocalizedStringKey(header.submit), action: handler.onSubmit)
                        .font(Font.body.weight(.bold))
                }
            }
        }
    }
}


// MARK: - CounterDivider

extension TextEditorView {
    
    struct CounterDivider: View {
        @EnvironmentObject private var model: TextEditorModel
        private var counter: TextEditorModel.Counter { model.counter }
        @State private var count = 0
        private var countPercentage: CGFloat { CGFloat(count) / CGFloat(counter.max) }
        var body: some View {
            HStack {
                ZStack {
                    VStack { Divider() }
                    Render(if: counter.max > 0) {
                        RoundedRectangle(cornerRadius: 0.5, style: .continuous)
                            .frame(height: 1)
                            .foregroundColor(counterColor)
                            .transformEffect(.init(scaleX: min(countPercentage, 1), y: 1))
                            .onReceive(model.$field.map(\.text).map(\.count), assignTo: $count)
                    }
                }
                Render(if: counter.max > 0 && counter.count != nil) {
                    Text(counter.count!(count, counter.max))
                        .font(.caption2)
                        .foregroundColor(counterColor)
                }
            }
        }
        
        var counterColor: Color {
            switch true {
            case count < counter.max: return Color(counter.colors.min)
            case count == counter.max: return Color(counter.colors.max)
            default: return Color(counter.colors.exceeded)
            }
        }
    }
}


// MARK: - TextView

extension TextEditorView {
    
    struct TextView: View {
        
        @EnvironmentObject private var model: TextEditorModel
        
        @State private var components = Components()
        
        var body: some View {
            ZStack(alignment: .top) {
                UIViewWrapper(onMake: { components.textView })
                Text(LocalizedStringKey(model.field.placeholder))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(.placeholderText))
                    .opacity(model.field.text.isEmpty ? 1 : 0)
            }
            .onAppear(perform: setup)
            .onReceive(model.$field, perform: update)
            
        }
        
        private func update(with field: TextEditorModel.Field) {
            let textView = components.textView
            if textView.text != field.text {
                textView.text = field.text
            }
            textView.keyboardDismissMode = field.keyboardDismissMode
        }
        
        private func update(with counter: TextEditorModel.Counter) {
            
        }
        
        private func setup() {
            components.delegate.model = model
            
            let textView = components.textView
            textView.delegate = components.delegate
            textView.font = .init(style: .body)
            textView.textContainerInset = .init(top: 0, left: -4, bottom: 0, right: -4)
            
            if model.field.isInitiallyActive {
                textView.becomeFirstResponder()
            }
        }
    }
}


// MARK: - TextView's Components

extension TextEditorView {
    
    struct Components {
        
        let textView = UITextView()
        
        let delegate = Delegate()
    }
    
    class Delegate: NSObject, UITextViewDelegate {
        
        weak var model: TextEditorModel?
        
        func textViewDidChange(_ textView: UITextView) {
            guard let model = model else { return }
            model.field.text = textView.text
        }
    }
}


// MARK: - ViewController

public class TextEditorViewController: UIViewController {
    
    public let model: TextEditorModel
    
    private let content: UIHostingController<TextEditorView>
    
    public init(model: TextEditorModel) {
        self.model = model
        self.content = .init(rootView: .init(model: model))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addChild(content)
        view.addAutoLayoutSubview(content.view)
        content.view.constraint(fill: view)
        content.view.backgroundColor = .clear
        content.didMove(toParent: self)
    }
}


// MARK: - Previews

struct TextEditorView_Previews: PreviewProvider {
    static let model: TextEditorModel = {
        let model = TextEditorModel()
        model.header.title = "Text Editor"
        model.field.text = ""
        model.field.placeholder = "placeholder"
        model.counter.max = 10
        return model
    }()
    static var previews: some View {
        TextEditorView(model: model)
    }
}
