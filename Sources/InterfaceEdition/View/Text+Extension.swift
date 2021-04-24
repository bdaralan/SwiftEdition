import SwiftUI
import BuilderEdition


extension Text {

    public static func build(@ObjectBuilder builder: () -> [Text]) -> Text {
        builder().reduce(Text(""), +)
    }
}


struct TextBuilder_Previews: PreviewProvider {
    static var previews: some View {
        Text.build {
            Text("Hello").foregroundColor(.red)
            Text(" ").foregroundColor(.blue)
            Text("World").foregroundColor(.green)
        }
    }
}
