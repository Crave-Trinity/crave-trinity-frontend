//
//  ┌────────────────────────────────────────────────┐
//  │ CravePhone/Data/DataSources/Remote/SecretsManager.swift
//  └────────────────────────────────────────────────┘
//  Description:
//     Single-responsibility manager for retrieving secrets
//     (like the OpenAI API key) from Secrets.plist.
//
//  S.O.L.I.D. Principles:
//   - (S)ingle Responsibility: This class does one thing well—fetch secrets.
//   - (O)pen for Extension: If you add more secrets in the future, just extend this manager.
//   - (L)iskov Substitution: A hypothetical protocol-based approach could swap in a different
//     secrets store if needed.
//   - (I)nterface Segregation: Keep it minimal—only expose what's necessary.
//   - (D)ependency Inversion: Higher-level code depends on this abstraction, not the raw .plist.
//
import Foundation

public enum SecretsManager {
    
    /// Retrieves the OpenAI API key from `Secrets.plist`.
    /// - Throws: `SecretsError.missingKey` if the key is not found.
    public static func openAIAPIKey() throws -> String {
        guard
            let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
            let plist = NSDictionary(contentsOfFile: filePath),
            let apiKey = plist["OPENAI_API_KEY"] as? String,
            !apiKey.isEmpty
        else {
            throw SecretsError.missingKey("OPENAI_API_KEY")
        }
        return apiKey
    }
}

/// Errors that could occur when fetching secrets.
public enum SecretsError: Error, LocalizedError {
    case missingKey(String)
    
    public var errorDescription: String? {
        switch self {
        case .missingKey(let keyName):
            return "Secrets.plist is missing the '\(keyName)' key, or the key is empty."
        }
    }
}

