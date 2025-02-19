//
//  CravingLogView.swift
//  CraveWatch
//
//  Created by [Your Name] on [Date].
//  Description: A watch UI that lets users enter a craving, select intensity,
//               and log it locally + transmit to the iPhone.
//
import SwiftUI
import SwiftData

struct CravingLogView: View {
    @Environment(\.modelContext) private var modelContext
    
    @ObservedObject var viewModel: CravingLogViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Header
                Text("Log Your Craving")
                    .font(.headline)
                    .padding(.top)
                
                // Custom text editor for watch input
                CraveTextEditor(
                    text: $viewModel.cravingDescription,
                    placeholder: "Describe your craving...",
                    characterLimit: 280
                )
                .padding()
                .background(Color(white: 0.95))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Stepper for intensity
                Stepper(value: $viewModel.intensity, in: 1...10) {
                    Text("Intensity: \(viewModel.intensity)")
                }
                .padding(.horizontal)
                
                // Log Craving button
                Button {
                    viewModel.logCraving(context: modelContext)
                } label: {
                    Text("Log Craving")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .disabled(viewModel.cravingDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            // Success alert
            .alert("Success", isPresented: $viewModel.showConfirmation) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your craving has been logged locally and sent to iPhone.")
            }
            // Error alert
            .alert("Error", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.dismissError() }
            )) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}

// MARK: - Preview
#Preview {
    let dummyService = WatchConnectivityService()
    let vm = CravingLogViewModel(connectivityService: dummyService)
    return CravingLogView(viewModel: vm)
        .modelContainer(for: WatchCravingEntity.self, inMemory: true)
}
