
import SwiftUI

struct EmergencyTriggerView: View {
    
    @StateObject var viewModel: EmergencyTriggerViewModel
    
    var body: some View {
        VStack {
            Text("Emergency Trigger")
                .font(.headline)
                .padding(.bottom, 8)
            
            Button(action: {
                viewModel.requestEmergency()
            }) {
                Text("Trigger EMS")
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            
            Spacer()
        }
        .alert("Confirm EMS Trigger", isPresented: $viewModel.showConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Confirm", role: .destructive) {
                viewModel.confirmEmergency()
            }
        } message: {
            Text("Are you sure you want to call emergency services?")
        }
        .alert("Emergency Triggered!", isPresented: $viewModel.showSuccessAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your request has been sent to the iPhone for EMS handling.")
        }
        .padding()
    }
}

