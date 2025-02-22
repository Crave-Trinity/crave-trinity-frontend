//
//  CravingAudioRecordingView.swift
//  CraveWatch
//
//  The first screen for recording cravings on the Apple Watch.
//  (C) 2030
//

import SwiftUI

/// A view that presents the interface for recording audio associated with a craving.
/// It leverages a view model to manage recording state and actions, and informs the coordinator when recording is complete.
struct CravingAudioRecordingView: View {
    
    // MARK: - Properties
    
    /// The view model responsible for audio recording logic.
    @StateObject private var viewModel: CravingAudioRecordingViewModel
    
    /// A closure to notify the coordinator that the user has finished with this screen.
    let onContinue: () -> Void
    
    // MARK: - Initialization
    
    /// Creates a new instance of `CravingAudioRecordingView`.
    ///
    /// - Parameters:
    ///   - viewModel: An instance of `CravingAudioRecordingViewModel` that drives the recording logic.
    ///   - onContinue: A closure that is called when the user is ready to proceed.
    init(viewModel: CravingAudioRecordingViewModel,
         onContinue: @escaping () -> Void) {
        // Initialize the StateObject with the provided view model.
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onContinue = onContinue
    }
    
    // MARK: - View Body
    
    var body: some View {
        VStack(spacing: 12) {
            // Title for the recording screen.
            Text("Record Craving")
                .font(.headline)
                .foregroundColor(.orange)
            
            // A custom button that reflects the current recording state.
            RecordingButton(isRecording: viewModel.isRecording) {
                // Toggle recording state when the button is pressed.
                viewModel.toggleRecording()
            }
            
            // Display a recording indicator if recording is in progress.
            if viewModel.isRecording {
                Text("Recording...")
                    .font(.footnote)
                    .foregroundColor(.red)
            }
            
            // Show a "Save & Continue" button if a recording exists and is not in progress.
            if !viewModel.isRecording && viewModel.hasRecording {
                Button("Save & Continue") {
                    // Save the current recording.
                    viewModel.saveRecording()
                    
                    // Notify the coordinator that recording is complete.
                    onContinue()
                }
                .buttonStyle(BorderedProminentButtonStyle())
            }
        }
        .padding()
    }
}
