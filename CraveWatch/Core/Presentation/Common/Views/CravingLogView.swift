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

/// The primary view that orchestrates the entire craving logging workflow.
/// This view combines the audio recording step and subsequent logging pages into a single TabView,
/// enabling smooth horizontal swiping between pages.
struct CravingLogView: View {
    // MARK: - Environment & Observed Objects
    
    /// The SwiftData model context injected from the environment,
    /// used for data persistence operations.
    @Environment(\.modelContext) private var context
    
    /// The current scene phase (active, inactive, or background) to handle lifecycle changes.
    @Environment(\.scenePhase) private var scenePhase
    
    /// The main view model managing state and business logic for the craving log flow.
    @ObservedObject var viewModel: CravingLogViewModel
    
    // MARK: - Audio ViewModel
    
    /// The view model responsible for audio recording functionality.
    /// This could be injected via a dependency container in a larger app.
    @StateObject private var audioViewModel = CravingAudioRecordingViewModel(
        useCase: CravingAudioRecordingUseCase(
            repository: CravingAudioRepositoryImpl()
        )
    )
    
    // MARK: - Focus State & Local UI State
    
    /// Focus state binding to control the text editor’s focus in child views.
    @FocusState private var isEditorFocused: Bool
    
    /// The current tab index representing the active page in the TabView.
    /// Default is 0, which typically starts on the audio recording page.
    @State private var currentTab: Int = 0
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            // The TabView hosts all pages of the logging workflow, enabling horizontal swiping.
            TabView(selection: $currentTab) {
                
                // PAGE 0: AUDIO RECORDING
                CravingAudioRecordingView(viewModel: audioViewModel) {
                    // "Save & Continue" callback advances to the next page.
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
            // Enable horizontal swiping using the page style.
            .tabViewStyle(.page)
            // Expand the TabView to fill the available space.
            .frame(width: geometry.size.width, height: geometry.size.height)
            // Hide scroll indicators for a cleaner UI.
            .scrollIndicators(.hidden)
            
            // MARK: - Scene Phase Handling
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .inactive || newPhase == .background {
                    // Insert any logic required when the app becomes inactive or moves to the background.
                    // For example, you might want to pause ongoing operations or save state.
                }
            }
            
            // MARK: - Overlays & Alerts
            
            // Overlay a progress indicator when a loading operation is in progress.
            .overlay(alignment: .center) {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            
            // Overlay a confirmation view when required.
            .overlay {
                if viewModel.showConfirmation {
                    ConfirmationOverlay(isPresented: $viewModel.showConfirmation)
                }
            }
            
            // Present an alert when an error occurs.
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
            
            // When the confirmation overlay is dismissed, optionally reset the tab to the start.
            .onChange(of: viewModel.showConfirmation) { _, newVal in
                if !newVal {
                    currentTab = 0
                }
            }
        }
    }
}
