//VitalsView.swift

import SwiftUI

struct VitalsView: View {
    
    @StateObject var viewModel: VitalsViewModel

    var body: some View {
        VStack {
            if let hr = viewModel.heartRate {
                Text("Heart Rate: \(Int(hr)) BPM")
                    .font(.title2)
                    .padding(.bottom, 4)
            } else {
                Text("No heart rate data yet")
                    .foregroundColor(.secondary)
            }
            
            if viewModel.isAuthorized {
                Text("HealthKit Authorized")
                    .foregroundColor(.green)
                    .padding(.top, 2)
            } else {
                Button("Authorize HealthKit") {
                    Task {
                        await viewModel.requestAuthorization()
                    }
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
    }
}

