//=================================================================
// 2) SecretsManager.swift
//    CravePhone/Data/DataSources/Remote/SecretsManager.swift
//=================================================================

import Foundation

public enum SecretsManager {
    /// Retrieves the OpenAI API key from `Secrets.plist`.
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

public enum SecretsError: Error, LocalizedError {
    case missingKey(String)

    public var errorDescription: String? {
        switch self {
        case .missingKey(let keyName):
            return "Secrets.plist is missing the '\(keyName)' key, or the key is empty."
        }
    }
}
