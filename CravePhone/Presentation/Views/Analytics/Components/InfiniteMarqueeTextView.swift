//infinitemarqueetextview

import SwiftUI

/// Infinite scrolling marquee text for the top header, with multiple lines and directions.
public struct InfiniteMarqueeTextView: View {
    let lines: [String]
    let spacing: CGFloat = 20

    public init(lines: [String]) {
        self.lines = lines
    }

    public var body: some View {
        VStack(spacing: spacing) { // Add spacing between lines
            ForEach(lines.indices, id: \.self) { index in
                // Fixing ternary operator syntax for direction
                MarqueeText(text: lines[index], direction: index == 1 ? .leftToRight : .rightToLeft)
            }
        }
        .padding(.top, 20) // Top padding for the marquee
    }
}

struct MarqueeText: View {
    let text: String
    let direction: ScrollDirection
    @State private var offset: CGFloat = 0
    @State private var textWidth: CGFloat = 0
    @State private var timer: Timer? = nil

    enum ScrollDirection {
        case leftToRight, rightToLeft
    }

    @State private var geoWidth: CGFloat = 0 // State variable to store geometry width

    var body: some View {
        GeometryReader { geo in
            Text(text)
                .font(.system(size: 18, weight: .semibold, design: .rounded)) // Set font properties
                .foregroundColor(.white.opacity(0.8)) // Set text color with opacity
                .background(
                    GeometryReader { textGeo in
                        Color.clear
                            .onAppear {
                                // Explicitly set textWidth instead of using implicit capture
                                textWidth = textGeo.size.width
                            }
                    }
                )
                .offset(x: offset, y: 0) // Apply scrolling offset
                .frame(width: geo.size.width, alignment: .leading) // Set explicit width to avoid layout issues
                .onAppear {
                    // Set geoWidth explicitly to avoid implicit capture of geo
                    geoWidth = geo.size.width

                    // Fixing offset calculation with correct syntax
                    offset = direction == .leftToRight ? geoWidth : -textWidth
                    timer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { _ in
                        // Adjust offset based on scroll direction
                        offset += direction == .leftToRight ? -1 : 1
                        // Handle text wrap around based on direction
                        if direction == .leftToRight && offset < -textWidth {
                            offset = geoWidth
                        } else if direction == .rightToLeft && offset > geoWidth {
                            offset = -textWidth
                        }
                    }
                }
                .onDisappear {
                    // Clean up the timer to avoid memory leaks
                    timer?.invalidate()
                    timer = nil
                }
        }
    }
}
