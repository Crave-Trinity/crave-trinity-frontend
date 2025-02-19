

import SwiftUI

struct CravingLogView: View {
    
    @StateObject var viewModel: CravingLogViewModel

    var body: some View {
        VStack {
            Text("Log Craving")
                .font(.headline)
            
            TextField("Description", text: $viewModel.cravingDescription)
                .textFieldStyle(.roundedBorder)
                .padding([.leading, .trailing], 8)
            
            HStack {
                Text("Intensity: \(viewModel.intensity)")
                Slider(value: Binding(
                    get: { Double(viewModel.intensity) },
                    set: { viewModel.intensity = Int($0) }
                ), in: 1...10, step: 1)
                .frame(width: 100)
            }
            .padding(.vertical, 4)

            Button(action: {
                viewModel.logCraving()
            }) {
                Text("Send")
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 8)
            
            Spacer()
        }
        .alert("Success!", isPresented: $viewModel.showConfirmation) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Craving sent to iPhone.")
        }
        .alert(item: Binding<String?>(
            get: { viewModel.errorMessage },
            set: { _ in viewModel.dismissError() }
        )) { errMsg in
            Alert(title: Text("Error"), message: Text(errMsg), dismissButton: .default(Text("OK")))
        }
        .padding()
    }
}


