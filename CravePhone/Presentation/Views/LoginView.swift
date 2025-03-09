// File: LoginView.swift
// PURPOSE: Presents the login UI.
import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome to Crave!")
                .font(.largeTitle).bold()
            TextField("Email", text: $viewModel.email)
                .textContentType(.username)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            SecureField("Password", text: $viewModel.password)
                .textContentType(.password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            Button(action: { viewModel.loginWithEmailPassword() }) {
                Text("Sign In")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(viewModel.isLoading ? Color.gray : Color.blue)
                    .cornerRadius(8)
            }
            .disabled(viewModel.isLoading)
            Divider().padding(.vertical, 8)
            Button(action: {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    viewModel.loginWithGoogle(presentingWindow: scene)
                }
            }) {
                HStack {
                    Image(systemName: "globe")
                    Text("Sign in with Google")
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(viewModel.isLoading ? Color.gray : Color.red)
                .cornerRadius(8)
            }
            .disabled(viewModel.isLoading)
            if let error = viewModel.errorMessage, !error.isEmpty {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
            }
        }
        .padding()
    }
}
