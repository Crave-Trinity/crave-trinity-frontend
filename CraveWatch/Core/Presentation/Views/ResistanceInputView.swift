// CraveWatch/Core/Presentation/Views/ResistanceInputView.swift (NEW)
import SwiftUI

struct ResistanceInputView: View {
    @Binding var resistance: Int
    var onResistanceChanged: () -> Void  // Closure for haptic feedback


    var body: some View {
        VStack {
            Text("Resistance: \(resistance)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.green)

            Slider(value: Binding(
                get: { Double(resistance) },
                set: { newValue in
                    resistance = Int(newValue)
                    onResistanceChanged()
                }
            ), in: 0...10, step: 1)  // Resistance can be 0
            .tint(.green)
        }
    }
}

