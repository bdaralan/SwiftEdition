import SwiftUI
import BuilderEdition


extension Text {

    public static func concatenate(@ResultBuilder builder: () -> [Text]) -> Text {
        builder().reduce(Text(""), +)
    }
}


struct TextBuilder_Previews: PreviewProvider {
    static var previews: some View {
        Text.concatenate {
            Text("Hello").foregroundColor(.red)
            Text(" ").foregroundColor(.blue)
            Text("World").foregroundColor(.green)
        }
    }
}
