import SwiftUI

struct VerticalIntensityBar: View {
    @Binding var value: Int  // 0..10
    
    @State private var crownValue: Double
    
    private let barHeight: CGFloat = 60
    private let barWidth: CGFloat = 8
    
    init(value: Binding<Int>) {
        _value = value
        _crownValue = State(initialValue: Double(value.wrappedValue))
    }
    
    var body: some View {
        // A vertical bar that uses the digital crown
        ZStack(alignment: .bottom) {
            // Background track
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(Color.gray.opacity(0.3))
                .frame(width: barWidth, height: barHeight)
            
            // Fill portion
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(.blue)
                .frame(width: barWidth, height: fillHeight())
                .animation(.easeInOut, value: value)
        }
        .focusable(true)
        .digitalCrownRotation(
            $crownValue,
            from: 0, through: 10, by: 1,
            sensitivity: .low,
            isContinuous: false
        )
        .onChange(of: crownValue) { oldVal, newVal in
            let newValue = min(10, max(0, Int(newVal)))
            if newValue != value {
                value = newValue
                WatchHapticManager.shared.play(.selection)
            }
        }
    }
    
    private func fillHeight() -> CGFloat {
        let fraction = CGFloat(value) / 10
        return fraction * barHeight
    }
}
