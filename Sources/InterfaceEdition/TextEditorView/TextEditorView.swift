import SwiftUI
import AutoLayoutEdition


public struct TextEditorView: View {
    
    @Binding var model: TextEditorViewModel
    
    private let delegate = Delegate()
    
    public init(model: Binding<TextEditorViewModel>) {
        _model = model
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            HeaderView(header: $model.header, delegate: delegate)
            CounterDivider(counter: $model.counter, field: $model.field, delegate: delegate)
            TextViewWrapper(field: $model.field)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
    }
}


// MARK: - HeaderView

extension TextEditorView {
 
    struct HeaderView: View {
        @Binding var header: TextEditorViewModel.Header
        let delegate: Delegate
        var body: some View {
            HStack {
                Text(LocalizedStringKey(header.title))
                    .font(Font.title3.weight(.bold))
                Spacer()
                HStack(spacing: 12) {
                    Button(LocalizedStringKey(header.cancel), action: delegate.onCancel ?? {})
                        .font(.body)
                    Button(LocalizedStringKey(header.submit), action: delegate.onCommit ?? {})
                        .font(Font.body.weight(.bold))
                }
            }
        }
    }
}


// MARK: - CounterDivider

extension TextEditorView {
    
    struct CounterDivider: View {
        
        @Binding var counter: TextEditorViewModel.Counter
        @Binding var field: TextEditorViewModel.Field
        let delegate: Delegate
        
        @State private var count = 0
        
        var countEnabled: Bool {
            counter.max > 0
        }
        
        var countTransformedWidth: CGAffineTransform {
            let percentage = Double(count) / Double(counter.max)
            let x = min(percentage, 1)
            return .init(scaleX: x, y: 1)
        }
        
        var countText: String {
            let max = counter.max
            let text = delegate.onCountTextWillChange?(count, max).empty(replacement: "hello")
            return text ?? "\(count)/\(max)"
        }
        
        var countColor: Color {
            switch true {
            case count < counter.max: return counter.colors.min
            case count > counter.max: return counter.colors.exceeded
            default: return counter.colors.max
            }
        }
        
        var body: some View {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 0.5, style: .continuous)
                        .frame(height: 0.5)
                        .foregroundColor(Color(.opaqueSeparator))
                    Render(if: countEnabled) {
                        RoundedRectangle(cornerRadius: 0.5, style: .continuous)
                            .frame(height: 1)
                            .foregroundColor(countColor)
                            .transformEffect(countTransformedWidth)
                    }
                }
                Render(if: countEnabled) {
                    Text(countText)
                        .font(.caption2)
                        .foregroundColor(countColor)
                        .onChange(of: field.text.count, assignTo: $count)
                }
            }
        }
    }
}


// MARK: - TextView

extension TextEditorView {
    
    struct TextViewWrapper: View {
        
        @Binding var field: TextEditorViewModel.Field
        
        @State private var components = Components()
        private var textView: UITextView { components.textView }
        private var textViewDelegate: TextViewDelegate { components.textViewDelegate }
        
        @State private var placeholderOpacity = 1.0
        
        var body: some View {
            ZStack(alignment: .top) {
                UIViewWrapper(onMake: makeTextView)
                Render(if: field.text.isEmpty) {
                Text(LocalizedStringKey(field.placeholder))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(.placeholderText))
                    .opacity(placeholderOpacity)
                }
            }
            .onAppear(perform: setup)
            .onChange(of: field.text, perform: updateTextView)
        }
        
        private func updateTextView(text: String) {
            guard textView.text != text else { return }
            textView.text = text
        }
        
        private func setup() {
            textView.text = field.text
            textView.keyboardDismissMode = field.keyboardDismissMode
        }
        
        private func makeTextView() -> UITextView {
            textView.font = .init(style: .body)
            textView.textContainerInset = .init(top: 0, left: -4, bottom: 0, right: -4)
            
            textView.delegate = textViewDelegate
            textViewDelegate.onTextChange = { text in
                field.text = text
                placeholderOpacity = text.isEmpty ? 1 : 0
            }
            
            if field.isInitiallyActive {
                textView.becomeFirstResponder()
            }
            
            return textView
        }
        
        struct Components {
            let textView = UITextView()
            let textViewDelegate = TextViewDelegate()
        }
        
        class TextViewDelegate: NSObject, UITextViewDelegate {
            var onTextChange: ((String) -> Void)?
            
            func textViewDidChange(_ textView: UITextView) {
                onTextChange?(textView.text)
            }
        }
    }
}


// MARK: Delegate

extension TextEditorView {
    
    class Delegate {
        var onCancel: (() -> Void)?
        var onCommit: (() -> Void)?
        var onCountTextWillChange: ((Int, Int) -> String)?
    }
    
    public func onCancel(perform action: @escaping () -> Void) -> Self {
        delegate.onCancel = action
        return self
    }
    
    public func onCommit(perform action: @escaping () -> Void) -> Self {
        delegate.onCommit = action
        return self
    }
    
    /// A text to display as counter.
    public func onCountTextWillChange(perform action: @escaping (_ count: Int, _ max: Int) -> String) -> Self {
        delegate.onCountTextWillChange = action
        return self
    }
}


// MARK: - Previews

struct TextEditorView_Previews: PreviewProvider {
    struct PreviewContent: View {
        @State private var model = TextEditorViewModel()
        var body: some View {
            TextEditorView(model: $model)
                .onCancel {
                }
                .onCommit {
                }
                .onCountTextWillChange { count, max in
                    "\(count) of \(max)"
                }
                .onAppear {
                    model.header.title = "Text Editor"
                    model.field.text = ""
                    model.field.placeholder = "placeholder"
                    model.counter.max = 10
                }
        }
    }
    static var previews: some View {
        PreviewContent()
    }
}
