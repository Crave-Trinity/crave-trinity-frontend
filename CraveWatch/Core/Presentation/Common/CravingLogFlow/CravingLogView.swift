import SwiftUI
import SwiftData

struct CravingLogView: View {
    // MARK: - Environment & Observed Objects
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var scenePhase

    @ObservedObject var viewModel: CravingLogViewModel

    // MARK: - Focus States & Local State
    @FocusState private var isEditorFocused: Bool
    @State private var currentTab: Int = 1

    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            TabView(selection: $currentTab) {
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
            .tabViewStyle(.page)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .scrollIndicators(.hidden)

            // MARK: - Scene Phase
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .inactive || newPhase == .background {
                    // e.g. currentTab = 1 or other logic
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
                    // Reset to page 1 after confirmation
                    currentTab = 1
                }
            }
        }
    }
}

