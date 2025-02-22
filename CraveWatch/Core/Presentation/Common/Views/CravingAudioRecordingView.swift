//
//  CravingAudioRecordingView.swift
//  CraveWatch
//
//  The first screen for recording cravings on the Apple Watch.
//  (C) 2030
//

import SwiftUI

struct CravingAudioRecordingView: View {
    @StateObject private var viewModel: CravingAudioRecordingViewModel
    
    // 1) A closure that tells the coordinator "I'm done—move on!"
    let onContinue: () -> Void
    
    // 2) The initializer matches the one in your coordinator
    init(viewModel: CravingAudioRecordingViewModel,
         onContinue: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onContinue = onContinue
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Record Craving")
                .font(.headline)
                .foregroundColor(.orange)
            
            RecordingButton(isRecording: viewModel.isRecording) {
                viewModel.toggleRecording()
            }
            
            if viewModel.isRecording {
                Text("Recording...").font(.footnote).foregroundColor(.red)
            }
            
            if !viewModel.isRecording && viewModel.hasRecording {
                Button("Save & Continue") {
                    viewModel.saveRecording()
                    
                    // 3) After saving, we call onContinue() to notify the coordinator
                    onContinue()
                }
                .buttonStyle(BorderedProminentButtonStyle())
            }
        }
        .padding()
    }
}
