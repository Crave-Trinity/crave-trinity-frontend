import SwiftUI

struct WatchCraveTextEditor: View {
    @Binding var text: String
    var primaryPlaceholder: String
    var secondaryPlaceholder: String
    @FocusState.Binding var isFocused: Bool
    var characterLimit: Int

    var body: some View {
        ZStack(alignment: .top) {
            if text.isEmpty && !isFocused {
                VStack(alignment: .center, spacing: 8) {
                    Text(primaryPlaceholder)
                        .font(.body)
                        .foregroundColor(.gray)
                    Text(secondaryPlaceholder)
                        .font(.footnote)
                        .foregroundColor(.gray.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 8)
            }

            TextField("", text: $text, axis: .vertical)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .onChange(of: text) { oldValue, newValue in
                    if newValue.count > characterLimit {
                        text = String(newValue.prefix(characterLimit))
                        WatchHapticManager.shared.play(.warning)
                    } else if oldValue.isEmpty && !newValue.isEmpty {
                        WatchHapticManager.shared.play(.selection)
                    }
                }
                .frame(minHeight: 60)
                .background(text.isEmpty && !isFocused ? .clear : Color.gray.opacity(0.2))
                .cornerRadius(8)
                .focused($isFocused)
                .onTapGesture {
                    isFocused = true
                    WatchHapticManager.shared.play(.selection)
                }
                .opacity(text.isEmpty && !isFocused ? 0.7 : 1)
        }
    }
}
