//
//  CravingLogUltraCoolLogPageView.swift
//  CraveWatch
//
//  The final step in the craving logging flow: actually log the craving via `viewModel.logCraving(context:)`.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI
import SwiftData

/// A view that represents the final step in the craving logging process.
/// When the user taps the ultra-cool log button, the craving is logged via the view model.
struct CravingLogUltraCoolLogPageView: View {
    // MARK: - Dependencies
    
    /// The view model that manages the state and logic for logging cravings.
    @ObservedObject var viewModel: CravingLogViewModel
    
    /// The SwiftData context used for persisting the craving.
    let context: ModelContext

    // MARK: - View Body
    
    var body: some View {
        VStack(spacing: 12) {
            // Optionally, you can add a title or descriptive text here.
            
            // The UltraCoolLogButton is a standalone component that triggers the logging action.
            UltraCoolLogButton {
                // Trigger the logging process using the provided context.
                viewModel.logCraving(context: context)
            }
        }
        .padding()
    }
}

// Note: The definition of `UltraCoolLogButton` is maintained in a separate file
// to promote reusability and separation of concerns.
