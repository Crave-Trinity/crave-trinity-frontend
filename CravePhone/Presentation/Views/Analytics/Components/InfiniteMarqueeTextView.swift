/*
 ┌───────────────────────────────────────────────────────────┐
 │  Directory: CravePhone/Views/Analytics/Components        │
 │  Production-Ready SwiftUI Layout Fix:                    │
 │  InfiniteMarqueeTextView                                 │
 │  Notes:                                                  │
 │   - Smoother offset logic, proportion-based.             │
 │   - Timer cleanup onDisappear.                           │
 └───────────────────────────────────────────────────────────┘
*/

import SwiftUI

public struct InfiniteMarqueeTextView: View {
    let lines: [String]
    let spacing: CGFloat = 20
    
    public init(lines: [String]) {
        self.lines = lines
    }
    
    public var body: some View {
        VStack(spacing: spacing) {
            ForEach(lines.indices, id: \.self) { index in
                MarqueeText(
                    text: lines[index],
                    direction: index.isMultiple(of: 2) ? .rightToLeft : .leftToRight
                )
            }
        }
        .padding(.top, 20)
    }
}

fileprivate struct MarqueeText: View {
    let text: String
    let direction: ScrollDirection
    @State private var offset: CGFloat = 0
    @State private var textWidth: CGFloat = 0
    @State private var geoWidth: CGFloat = 0
    @State private var timer: Timer? = nil
    
    enum ScrollDirection {
        case leftToRight, rightToLeft
    }
    
    var body: some View {
        GeometryReader { geo in
            Text(text)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
                .background(
                    GeometryReader { textGeo in
                        Color.clear
                            .onAppear {
                                textWidth = textGeo.size.width
                            }
                    }
                )
                .offset(x: offset)
                .frame(width: geo.size.width, alignment: .leading)
                .onAppear {
                    geoWidth = geo.size.width
                    offset = direction == .leftToRight ? geoWidth : -textWidth
                    
                    timer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { _ in
                        offset += direction == .leftToRight ? -1 : 1
                        if direction == .leftToRight && offset < -textWidth {
                            offset = geoWidth
                        } else if direction == .rightToLeft && offset > geoWidth {
                            offset = -textWidth
                        }
                    }
                }
                .onDisappear {
                    timer?.invalidate()
                    timer = nil
                }
        }
    }
}

