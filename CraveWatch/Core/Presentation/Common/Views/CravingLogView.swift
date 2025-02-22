//
//  CravingLogView.swift
//  CraveWatch
//
//  A unified container that includes BOTH the audio recording page
//  AND the original 5 logging pages in a single TabView for swiping.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import SwiftUI
import SwiftData

struct CravingLogView: View {
    // MARK: - Environment & Observed Objects
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var scenePhase
    
    // The main view model for the old craving log flow.
    @ObservedObject var viewModel: CravingLogViewModel
    
    // MARK: - Audio ViewModel
    // If you have a WatchDependencyContainer, you can inject this from there.
    // Otherwise, create it here for demo purposes:
    @StateObject private var audioViewModel = CravingAudioRecordingViewModel(
        useCase: CravingAudioRecordingUseCase(
            repository: CravingAudioRepositoryImpl()
        )
    )
    
    // MARK: - Focus State & Local UI State
    @FocusState private var isEditorFocused: Bool
    
    // Set currentTab to 0 if you want the app to START on the audio page.
    @State private var currentTab: Int = 0
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            // A single TabView that holds ALL pages in your watch flow.
            TabView(selection: $currentTab) {
                
                // PAGE 0: AUDIO RECORDING
                CravingAudioRecordingView(viewModel: audioViewModel) {
                    // "Save & Continue" callback can jump to the next tab
                    currentTab = 1
                }
                .tag(0)
                
                // PAGE 1: TRIGGER
                CravingLogTriggerPageView(
                    viewModel: viewModel,
                    isEditorFocused: $isEditorFocused,
                    onNext: { currentTab = 2 }
                )
                .tag(1)

                // PAGE 2: INTENSITY
                CravingLogIntensityPageView(
                    viewModel: viewModel,
                    onNext: { currentTab = 3 }
                )
                .tag(2)

                // PAGE 3: RESISTANCE
                CravingLogResistancePageView(
                    viewModel: viewModel,
                    onNext: { currentTab = 4 }
                )
                .tag(3)

                // PAGE 4: ALLY CONTACT
                CravingLogAllyContactPageView(
                    viewModel: viewModel
                )
                .tag(4)

                // PAGE 5: ULTRA COOL LOG
                CravingLogUltraCoolLogPageView(
                    viewModel: viewModel,
                    context: context
                )
                .tag(5)
            }
            // This style is what enables horizontal swiping on watchOS
            .tabViewStyle(.page)
            
            // Use the entire geometry for the TabView
            .frame(width: geometry.size.width, height: geometry.size.height)
            .scrollIndicators(.hidden)
            
            // MARK: - Scene Phase Changes
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .inactive || newPhase == .background {
                    // Insert any logic to handle scene changes, if needed.
                }
            }
            
            // MARK: - Overlays & Alerts
            .overlay(alignment: .center) {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .overlay {
                if viewModel.showConfirmation {
                    ConfirmationOverlay(isPresented: $viewModel.showConfirmation)
                }
            }
            .alert("Error",
                   isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { newVal in
                        if !newVal { viewModel.dismissError() }
                    }
                   )
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .onChange(of: viewModel.showConfirmation) { _, newVal in
                if !newVal {
                    // Reset to the first page after confirmation, if desired
                    currentTab = 0
                }
            }
        }
    }
}
