//
//  AllySupportView.swift
//  CraveWatch
//
//  Description:
//    A simple view with "Text Ally" and "Call Ally" buttons.
//

import SwiftUI

struct AllySupportView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Ally Support")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 4)

            Button("Text Ally") {
                // Here, you might call watchConnectivityService.sendMessage(...)
                // or some domain logic to actually text from the iPhone.
                print("Text Ally tapped.")
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)

            Button("Call Ally") {
                // Similarly, logic for a phone call or watchConnectivityService.
                print("Call Ally tapped.")
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
        }
        .padding()
    }
}

