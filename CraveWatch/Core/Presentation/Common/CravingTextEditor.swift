import SwiftUI

public struct CraveTextEditor: View {
    @Binding var text: String
    let placeholder: String
    let characterLimit: Int
    
    public init(text: Binding<String>, placeholder: String, characterLimit: Int) {
        self._text = text
        self.placeholder = placeholder
        self.characterLimit = characterLimit
    }
    
    public var body: some View {
        TextField(placeholder, text: $text)
            .textFieldStyle(.plain)
            .frame(minHeight: 40)
    }
}
