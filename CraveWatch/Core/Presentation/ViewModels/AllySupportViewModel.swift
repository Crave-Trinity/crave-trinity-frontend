//
//  AllySupportViewModel.swift
//  CraveWatch
//
//  A placeholder ViewModel for managing "Ally Support" logic—e.g. sending messages to a sponsor,
//  friend, or support group.
//
//  (C) 2030 - Uncle Bob & Steve Jobs Approved
//

import Foundation
import Combine

@MainActor
class AllySupportViewModel: ObservableObject {
    // MARK: - Inputs
    @Published var selectedAlly: String = ""
    @Published var messageText: String = ""

    // MARK: - Outputs
    @Published var canSend: Bool = false

    private var cancellables = Set<AnyCancellable>()

    // Example: list of allies
    let allies: [String] = ["Sponsor", "Friend", "Therapist", "Support Group"]

    init() {
        // Observe changes in selectedAlly and messageText to determine if user can send
        Publishers.CombineLatest($selectedAlly, $messageText)
            .map { ally, message -> Bool in
                return !ally.isEmpty && !message.isEmpty
            }
            .assign(to: \.canSend, on: self)
            .store(in: &cancellables)
    }

    func sendMessage() {
        guard canSend else { return }
        // TODO: Integrate with your connectivity service or networking
        // to actually send the message to the selected ally.
        print("Sending '\(messageText)' to ally: \(selectedAlly)")

        // Reset
        selectedAlly = ""
        messageText = ""
    }
}
