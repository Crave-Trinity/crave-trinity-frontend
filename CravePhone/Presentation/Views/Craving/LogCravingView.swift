//
//  LogCravingView.swift
//  CravePhone/Presentation/Views/Craving
//  DESCRIPTION: Main view that orchestrates logging a craving,
//               including the description section, location, etc.
//

import SwiftUI

struct LogCravingView: View {
    // Accept the view model from outside
    @StateObject private var viewModel: LogCravingViewModel
    
    // Custom initializer so the DI container can supply the view model.
    init(viewModel: LogCravingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // The description section
                CravingDescriptionSectionView(viewModel: viewModel)
                
                // Location
                VStack(alignment: .leading, spacing: 8) {
                    Text("Where are you?")
                        .font(.headline)
                    CraveTextEditor(text: $viewModel.location,
                                    placeholder: "Current, Home, Work, Social, etc.",
                                    minHeight: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary, lineWidth: 1)
                        )
                }
                
                // People
                VStack(alignment: .leading, spacing: 8) {
                    Text("Who are you with?")
                        .font(.headline)
                    CraveTextEditor(text: $viewModel.people,
                                    placeholder: "Alone, Friends, Family, Coworkers...",
                                    minHeight: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary, lineWidth: 1)
                        )
                }
                
                // Trigger
                VStack(alignment: .leading, spacing: 8) {
                    Text("What triggered it?")
                        .font(.headline)
                    CraveTextEditor(text: $viewModel.trigger,
                                    placeholder: "What might have caused this craving?",
                                    minHeight: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary, lineWidth: 1)
                        )
                }
                
                // Intensity
                VStack(alignment: .leading, spacing: 8) {
                    Text("Intensity")
                        .font(.headline)
                    Slider(value: $viewModel.intensity, in: 0...10, step: 1)
                    Text("\(Int(viewModel.intensity))")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                // Log button
                Button(action: {
                    viewModel.logCraving()
                }) {
                    Text("Log Craving")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.cornerRadius(8))
                }
                .padding(.top, 16)
            }
            .padding()
        }
        .navigationTitle("Log Craving")
        .navigationBarTitleDisplayMode(.inline)
    }
}
