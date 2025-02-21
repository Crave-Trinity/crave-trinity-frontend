// CraveWatch/Core/Presentation/Views/IntensityInputView.swift (NEW)
import SwiftUI

struct IntensityInputView: View {
    @Binding var intensity: Int
    var onIntensityChanged: () -> Void  // Closure for haptic feedback

    var body: some View {
        VStack {
            Text("Intensity: \(intensity)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.orange)

            Slider(value: Binding(
                get: { Double(intensity) },
                set: { newValue in
                    intensity = Int(newValue)
                    onIntensityChanged() // Trigger haptic
                }
            ), in: 1...10, step: 1)
            .tint(.orange)
        }
    }
}
