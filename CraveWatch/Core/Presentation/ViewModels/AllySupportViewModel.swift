//
//  AllySupportViewModel.swift
//  CraveWatch
//
//  A placeholder ViewModel for managing "Ally Support" logic—e.g. sending messages to a sponsor,
//  friend, or support group.
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import Foundation
import Combine

@MainActor
class AllySupportViewModel: ObservableObject {
    // MARK: - Inputs
    
    /// The ally selected by the user for support.
    @Published var selectedAlly: String = ""
    
    /// The message text that the user intends to send.
    @Published var messageText: String = ""
    
    // MARK: - Outputs
    
    /// A Boolean value indicating whether the message can be sent.
    /// This is computed based on whether both `selectedAlly` and `messageText` are non-empty.
    @Published var canSend: Bool = false
    
    // MARK: - Private Properties
    
    /// A set to store Combine subscriptions for automatic cancellation.
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Static Data
    
    /// A predefined list of allies available for support.
    let allies: [String] = ["Sponsor", "Friend", "Therapist", "Support Group"]
    
    // MARK: - Initialization
    
    /// Initializes a new instance of `AllySupportViewModel`.
    /// Sets up a publisher to monitor changes to `selectedAlly` and `messageText`
    /// and updates `canSend` accordingly.
    init() {
        Publishers.CombineLatest($selectedAlly, $messageText)
            .map { ally, message in
                // Allow sending only if both the ally and message fields are non-empty.
                return !ally.isEmpty && !message.isEmpty
            }
            .assign(to: \.canSend, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    /// Sends a message to the selected ally.
    /// This function verifies that the message can be sent, performs the send action,
    /// and then resets the input fields.
    func sendMessage() {
        // Ensure that both the ally and message are provided.
        guard canSend else { return }
        
        // TODO: Integrate with your connectivity service or networking to actually send the message.
        print("Sending '\(messageText)' to ally: \(selectedAlly)")
        
        // Reset the input fields after sending the message.
        selectedAlly = ""
        messageText = ""
    }
}
