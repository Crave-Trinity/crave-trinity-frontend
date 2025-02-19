import SwiftUI

struct HorizontalResistanceBar: View {
    @Binding var value: Int  // 0..10
    
    @State private var crownValue: Double
    
    private let barWidth: CGFloat = 120
    private let barHeight: CGFloat = 8
    
    init(value: Binding<Int>) {
        _value = value
        _crownValue = State(initialValue: Double(value.wrappedValue))
    }
    
    var body: some View {
        HStack {
            Text("0")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(Color.gray.opacity(0.3))
                    .frame(width: barWidth, height: barHeight)
                
                // Fill portion
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(.blue)
                    .frame(width: fillWidth(), height: barHeight)
                    .animation(.easeInOut, value: value)
            }
            
            Text("10")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        // Focusable so the digital crown can adjust it
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
    
    private func fillWidth() -> CGFloat {
        let fraction = CGFloat(value) / 10
        return fraction * barWidth
    }
}
