// File: Core/Presentation/Views/Craving/LogCravingView.swift
// Description:
// This view presents a form for logging a craving on the phone.
// It uses LogCravingViewModel to manage state and handle use case execution,
// and displays an alert if an error occurs.
import SwiftUI

@MainActor
public struct LogCravingView: View {
    @ObservedObject var viewModel: LogCravingViewModel

    public init(viewModel: LogCravingViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            Form {
                Section {
                    CraveTextEditor(
                        text: $viewModel.cravingText,
                        placeholder: "Enter craving...",
                        characterLimit: 280
                    )
                    .frame(minHeight: 120)
                }

                Section {
                    Button("Log Craving") {
                        Task {
                            await viewModel.logCraving()
                        }
                    }
                    .disabled(viewModel.cravingText.isEmpty)
                }
            }
            .navigationTitle("Log Craving")
        }
        .alert("Error",
               isPresented: $viewModel.showingAlert,
               actions: { Button("OK", role: .cancel) {} },
               message: { Text(viewModel.alertMessage) }
        )
    }
}

// MARK: - Preview
struct LogCravingView_Previews: PreviewProvider {
    static var previews: some View {
        let mockUseCase = MockAddCravingUseCase()
        let viewModel = LogCravingViewModel(addCravingUseCase: mockUseCase)
        return LogCravingView(viewModel: viewModel)
    }
}

// MARK: - Example MockAddCravingUseCase
final class MockAddCravingUseCase: AddCravingUseCaseProtocol {
    func execute(cravingText: String) async throws -> CravingEntity {
        guard cravingText.count >= 3 else {
            throw PhoneCravingError.invalidInput
        }
        return CravingEntity(text: cravingText)
    }
}
