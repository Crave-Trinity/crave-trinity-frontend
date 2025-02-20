// HorizontalWaveBackground.swift
// Core/Presentation/Common/DesignSystem/Components

import SwiftUI

/// MARK: - HorizontalWaveShape
/// A shape that draws a wave horizontally.
fileprivate struct HorizontalWaveShape: Shape {
    
    var waveWidth: CGFloat
    var phase: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midX = rect.midX
        path.move(to: CGPoint(x: midX, y: 0))
        
        for y in stride(from: 0, through: rect.height, by: 1) {
            let relativeY = y / 50
            let sineValue = sin(relativeY + phase)
            let xOffset = sineValue * waveWidth
            let x = midX + xOffset
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}

/// MARK: - HorizontalWaveBackground
/// A background view that layers multiple HorizontalWaveShape layers to create a moving wave effect.
public struct HorizontalWaveBackground: View {
    
    @State private var phase: CGFloat = 0
    private let waveWidth: CGFloat
    private let speed: CGFloat
    private let gradient: LinearGradient
    
    public init(
        waveWidth: CGFloat = 15,
        speed: CGFloat = 0.05,
        gradient: LinearGradient = LinearGradient(
            gradient: Gradient(colors: [
                Color.black.opacity(0.4),
                Color.gray.opacity(0.6)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
    ) {
        self.waveWidth = waveWidth
        self.speed = speed
        self.gradient = gradient
    }
    
    public var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ZStack {
                waveLayer(opacity: 0.5, offset: 0)
                waveLayer(opacity: 0.3, offset: 4)
                waveLayer(opacity: 0.2, offset: 8)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                phase = 2 * .pi * speed
            }
        }
    }
    
    private func waveLayer(opacity: Double, offset: CGFloat) -> some View {
        HorizontalWaveShape(waveWidth: waveWidth + offset, phase: phase)
            .fill(gradient)
            .opacity(opacity)
            .ignoresSafeArea()
    }
}
