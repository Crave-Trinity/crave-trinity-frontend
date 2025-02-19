import SwiftUI
import Charts

public struct AnalyticsCharts: View {
    public let data: [Date: Int]

    public init(data: [Date: Int]) {
        self.data = data
    }

    public var body: some View {
        Chart {
            ForEach(data.keys.sorted(), id: \.self) { date in
                BarMark(
                    x: .value("Date", date, unit: .day),
                    y: .value("Count", data[date] ?? 0)
                )
            }
        }
        .frame(height: 200)
    }
}

