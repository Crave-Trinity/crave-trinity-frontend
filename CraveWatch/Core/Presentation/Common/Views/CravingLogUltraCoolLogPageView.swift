//
//  CravingLogUltraCoolLogPageView.swift
//  CraveWatch
//
//  The final step: Actually log the craving via `viewModel.logCraving(context:)`.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI
import SwiftData

struct CravingLogUltraCoolLogPageView: View {
    // MARK: - Dependencies
    @ObservedObject var viewModel: CravingLogViewModel
    let context: ModelContext

    var body: some View {
        VStack(spacing: 12) {
            // Possibly show a title or additional text if wanted

            // Use the UltraCoolLogButton from your separate file
            UltraCoolLogButton {
                viewModel.logCraving(context: context)
            }
        }
        .padding()
    }
}

// Remove the inline definition of `UltraCoolLogButton` here!
// We rely on the standalone UltraCoolLogButton.swift.
