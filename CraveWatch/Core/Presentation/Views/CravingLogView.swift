//
//  CravingLogView.swift
//  CraveWatch
//
//  A 5‑page TabView(.page) flow on watchOS:
//    1) Trigger Page (Text Editor)
//    2) Intensity Page (digital crown slider)
//    3) Resistance Page (digital crown slider + black/green styling)
//    4) Ally Contact Page (Text/Call Buttons)
//    5) ULTRA COOL Log Craving Page
//
//  Uncle Bob & Steve Jobs Approved
//
//  (C) 2025
//

import SwiftUI
import SwiftData

struct CravingLogView: View {
    // MARK: - Environment
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var scenePhase

    // MARK: - ViewModel
    @ObservedObject var viewModel: CravingLogViewModel

    // MARK: - Focus and Crown State
    @FocusState private var isEditorFocused: Bool
    @State private var crownIntensity: Double = 5.0
    @State private var crownResistance: Double = 5.0

    // MARK: - Tab State
    @State private var currentTab: Int = 1

    var body: some View {
        GeometryReader { geometry in
            TabView(selection: $currentTab) {
                // 1) Trigger Page
                TriggerPageView(
                    viewModel: viewModel,
                    currentTab: $currentTab,
                    isEditorFocused: $isEditorFocused
                )
                .tag(1)

                // 2) Intensity Page
                IntensityPageView(
                    viewModel: viewModel,
                    currentTab: $currentTab,
                    crownIntensity: $crownIntensity
                )
                .tag(2)

                // 3) Resistance Page
                ResistancePageView(
                    viewModel: viewModel,
                    currentTab: $currentTab,
                    crownResistance: $crownResistance
                )
                .tag(3)

                // 4) Ally Contact Page
                AllyContactPageView()
                    .tag(4)

                // 5) UltraCool Log Page
                UltraCoolLogPageView(viewModel: viewModel, context: context)
                    .tag(5)
            }
            .tabViewStyle(.page)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .scrollIndicators(.hidden)

            // Observe scene phase changes
            .onChange(of: scenePhase) {
                if scenePhase == .inactive || scenePhase == .background {
                    // If desired, reset tab to 1 when backgrounded
                    // currentTab = 1
                }
            }

            // Show loading overlay
            .overlay(alignment: .center) {
                if viewModel.isLoading {
                    ProgressView()
                }
            }

            // Show confirmation overlay
            .overlay {
                if viewModel.showConfirmation {
                    ConfirmationOverlay(isPresented: $viewModel.showConfirmation)
                }
            }

            // Error Alert
            .alert("Error",
                   isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { newVal in
                        if !newVal { viewModel.dismissError() }
                    }
                   )
            ) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }

            // On confirmation close, reset to tab 1
            .onChange(of: viewModel.showConfirmation) {
                if !viewModel.showConfirmation {
                    currentTab = 1
                }
            }
        }
    }
}

//
// MARK: - 1) Trigger Page
//

fileprivate struct TriggerPageView: View {
    @ObservedObject var viewModel: CravingLogViewModel
    @Binding var currentTab: Int

    // The text editor focus
    @FocusState.Binding var isEditorFocused: Bool

    var body: some View {
        VStack(spacing: 8) {
            Text("Trigger")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))

            WatchCraveTextEditor(
                text: $viewModel.cravingText,
                primaryPlaceholder: "Log Craving",
                secondaryPlaceholder: "",
                isFocused: $isEditorFocused,
                characterLimit: 200
            )
            .frame(height: 80)

            Button(action: { currentTab = 2 }) {
                Text("Next")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 26)
                    .background(premiumBlueGradient)
                    .cornerRadius(6)
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isLoading)
        }
        .padding(.horizontal)
        .padding(.top, -2)
        .padding(.bottom, 6)
    }
}

//
// MARK: - 2) Intensity Page
//

fileprivate struct IntensityPageView: View {
    @ObservedObject var viewModel: CravingLogViewModel
    @Binding var currentTab: Int
    @Binding var crownIntensity: Double

    var body: some View {
        VStack(spacing: 12) {
            IntensityInputView(intensity: $viewModel.intensity) {
                viewModel.intensityChanged(viewModel.intensity)
            }

            Button(action: { currentTab = 3 }) {
                Text("Next")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 26)
                    .background(premiumOrangeGradient)
                    .cornerRadius(6)
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isLoading)
        }
        .focusable()
        .digitalCrownRotation(
            $crownIntensity,
            from: 1.0,
            through: 10.0,
            by: 1.0,
            sensitivity: .low,
            isContinuous: false,
            isHapticFeedbackEnabled: true
        )
        .onChange(of: crownIntensity) {
            viewModel.intensity = Int(crownIntensity)
        }
        .onAppear {
            crownIntensity = Double(viewModel.intensity)
        }
    }
}

//
// MARK: - 3) Resistance Page
//

fileprivate struct ResistancePageView: View {
    @ObservedObject var viewModel: CravingLogViewModel
    @Binding var currentTab: Int
    @Binding var crownResistance: Double

    var body: some View {
        ZStack {
            // Black background
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 12) {
                ResistanceInputView(resistance: $viewModel.resistance) {
                    viewModel.resistanceChanged(viewModel.resistance)
                }

                Button(action: { currentTab = 4 }) {
                    Text("Next")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 26)
                        .background(Color.green)
                        .cornerRadius(6)
                }
                .buttonStyle(.plain)
                .disabled(viewModel.isLoading)
            }
            .padding(.horizontal, 4)
        }
        .focusable()
        .digitalCrownRotation(
            $crownResistance,
            from: 0.0,
            through: 10.0,
            by: 1.0,
            sensitivity: .low,
            isContinuous: false,
            isHapticFeedbackEnabled: true
        )
        .onChange(of: crownResistance) {
            viewModel.resistance = Int(crownResistance)
        }
        .onAppear {
            crownResistance = Double(viewModel.resistance)
        }
    }
}

//
// MARK: - 4) Ally Contact Page
//

fileprivate struct AllyContactPageView: View {
    var body: some View {
        AllySupportView()
    }
}

//
// MARK: - 5) UltraCool Log Page
//

fileprivate struct UltraCoolLogPageView: View {
    @ObservedObject var viewModel: CravingLogViewModel
    var context: ModelContext

    var body: some View {
        VStack(spacing: 12) {
            // We removed "Ready to Log?" for a clean final screen
            UltraCoolLogButton {
                viewModel.logCraving(context: context)
            }
        }
    }
}

// MARK: - UltraCoolLogButton & ConfirmationOverlay

struct UltraCoolLogButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text("LOG CRAVING")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.pink, .purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(10)
                .shadow(color: Color.purple.opacity(0.4), radius: 3, x: 2, y: 2)
        }
        .buttonStyle(.plain)
    }
}

struct ConfirmationOverlay: View {
    @Binding var isPresented: Bool
    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.8)
                    .edgesIgnoringSafeArea(.all)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.green)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isPresented = false
                }
            }
        } else {
            EmptyView()
        }
    }
}

// MARK: - Gradients

fileprivate let premiumBlueGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.58, saturation: 0.8, brightness: 0.7),
        Color(hue: 0.58, saturation: 0.9, brightness: 0.4)
    ]),
    startPoint: .top,
    endPoint: .bottom
)

fileprivate let premiumOrangeGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.10, saturation: 0.8, brightness: 1.0),
        Color(hue: 0.10, saturation: 0.9, brightness: 0.6)
    ]),
    startPoint: .top,
    endPoint: .bottom
)

// MARK: - Stub Definitions (Sliders, AllySupport, etc.)

struct IntensityInputView: View {
    @Binding var intensity: Int
    var onIntensityChanged: () -> Void

    init(intensity: Binding<Int>, onIntensityChanged: @escaping () -> Void) {
        self._intensity = intensity
        self.onIntensityChanged = onIntensityChanged
    }

    var body: some View {
        VStack(spacing: 4) {
            Text("Intensity: \(intensity)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.orange)
            Slider(
                value: Binding(
                    get: { Double(intensity) },
                    set: { newValue in
                        intensity = Int(newValue)
                        onIntensityChanged()
                    }
                ),
                in: 1...10,
                step: 1
            )
            .tint(.orange)
        }
    }
}

struct ResistanceInputView: View {
    @Binding var resistance: Int
    var onResistanceChanged: () -> Void

    init(resistance: Binding<Int>, onResistanceChanged: @escaping () -> Void) {
        self._resistance = resistance
        self.onResistanceChanged = onResistanceChanged
    }

    var body: some View {
        VStack(spacing: 4) {
            Text("Resistance: \(resistance)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Slider(
                value: Binding(
                    get: { Double(resistance) },
                    set: { newValue in
                        resistance = Int(newValue)
                        onResistanceChanged()
                    }
                ),
                in: 0...10,
                step: 1
            )
            .tint(.green)
        }
    }
}

struct AllySupportView: View {
    var body: some View {
        VStack(spacing: 16) {
            Button("Text Ally") {
                print("Text Ally tapped.")
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)

            Button("Call Ally") {
                print("Call Ally tapped.")
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
        }
        .padding()
    }
}

//
//  WatchCraveTextEditor.swift
//  (Referenced in TriggerPageView above)
//

// Provide your actual `WatchCraveTextEditor` implementation here.
// If it's a simple TextEditor wrapper, keep it minimal
// so you have a short, testable subview.
