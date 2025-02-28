//
//  LogCravingView.swift
//  CravePhone
//
//  Description:
//    A SwiftUI screen that logs cravings with a top-down flow:
//      1. 🦊 Title + subtitle
//      2. Big text box with a multi-line placeholder
//      3. Craving Intensity slider
//      4. Resistance slider
//      5. A horizontal row of emotion chips
//      6. Record Craving button
//
//  Changes:
//    - Added speech recognition button to text box
//    - Enhanced text box visibility with border overlay
//    - Optimized emotion chips layout with reduced spacing
//

import SwiftUI

public struct LogCravingView: View {
    
    @ObservedObject var viewModel: LogCravingViewModel
    
    public init(viewModel: LogCravingViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            ZStack {
                // Subtle black/dark gradient background
                CraveTheme.Colors.primaryGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // 1) Title + Subtitle
                        headerSection
                        
                        // 2) Text Box (always shown, with multi-line placeholder)
                        textBoxSection
                        
                        // 3) Sliders
                        cravingIntensitySlider
                        resistanceSlider
                        
                        // 4) Horizontal Chips
                        emotionChipSection
                        
                        // 5) Record Button
                        recordCravingButton
                    }
                    .padding(24)
                    // Extra bottom padding so the button isn't clipped
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            // Alert Handling
            .alert(item: $viewModel.alertInfo) { info in
                Alert(title: Text(info.title),
                      message: Text(info.message),
                      dismissButton: .default(Text("OK")))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Subviews
extension LogCravingView {
    
    // 1) Title + Subtitle
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("🦊 Track Your Craving")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text("Share what you're craving to gain insights.")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // 2) Text Box with Speech Recognition
    private var textBoxSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            // ZStack allows us to overlay the mic button on the text field
            ZStack(alignment: .topTrailing) {
                // Enhanced text editor with more visible styling
                CraveTextEditor(
                    text: $viewModel.cravingDescription,
                    characterLimit: 300,
                    placeholderLines: [
                        .plain("What are you craving?"),
                        .plain("Any triggers?"),
                        .plain("Where are you?"),
                        .plain("Who are you with?"),
                    ]
                )
                // Attempt to center lines horizontally
                .multilineTextAlignment(.center)
                .frame(minHeight: 120)
                // Increased opacity for better visibility
                .background(Color.black.opacity(0.3))
                .cornerRadius(8)
                // Added subtle border for better definition
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                
                // Microphone button overlay - elegant speech integration
                Button(action: {
                    viewModel.toggleSpeechRecognition()
                }) {
                    Image(systemName: viewModel.isRecordingSpeech ? "waveform" : "mic.fill")
                        .font(.system(size: 18))
                        .foregroundColor(viewModel.isRecordingSpeech ? .orange : .white.opacity(0.8))
                        .padding(8)
                        .background(Color.black.opacity(0.4))
                        .clipShape(Circle())
                }
                .padding(8)
            }
        }
    }
    
    // 3a) Craving Intensity Slider
    private var cravingIntensitySlider: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Craving Intensity: \(Int(viewModel.cravingStrength))")
                .foregroundColor(.white)
                .font(.headline)
            Slider(value: $viewModel.cravingStrength, in: 1...10, step: 1)
                .accentColor(.orange)
        }
    }
    
    // 3b) Resistance Slider
    private var resistanceSlider: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Resistance: \(Int(viewModel.confidenceToResist))")
                .foregroundColor(.white)
                .font(.headline)
            Slider(value: $viewModel.confidenceToResist, in: 1...10, step: 1)
                .accentColor(.orange)
        }
    }
    
    // 4) Horizontal Chips with improved spacing
    private var emotionChipSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("How are you feeling?")
                .font(.headline)
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) { // Reduced from 12 to ensure better visibility
                    // Reorder states as requested: "Hungry", "Angry", "Lonely", "Tired", "Sad"
                    ForEach(["Hungry", "Angry", "Lonely", "Tired", "Sad"], id: \.self) { emotion in
                        OutlinedChip(emotion: emotion,
                                     isSelected: viewModel.selectedEmotions.contains(emotion)) {
                            // Tap toggles selection
                            viewModel.toggleEmotion(emotion)
                        }
                    }
                }
                .padding(.horizontal, 4) // Ensure chips don't touch screen edge
            }
        }
    }
    
    // 5) Record Craving Button
    private var recordCravingButton: some View {
        Button {
            Task {
                await viewModel.logCraving()
            }
        } label: {
            HStack {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Record Craving")
                        .fontWeight(.bold)
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(Color.orange)
            .cornerRadius(10)
        }
        .padding(.top, 10)
    }
}

// MARK: - OutlinedChip Subview
fileprivate struct OutlinedChip: View {
    
    let emotion: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Text(emotion)
            .font(.subheadline)
            .padding(.vertical, 6)
            .padding(.horizontal, 16)
            // Outline effect:
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.orange : Color.white.opacity(0.6), lineWidth: 2)
            )
            // Subtle fill behind the stroke if selected
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.orange.opacity(0.15) : Color.clear)
            )
            .foregroundColor(.white)
            .onTapGesture {
                onTap()
            }
    }
}
