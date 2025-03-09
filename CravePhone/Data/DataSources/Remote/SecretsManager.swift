//CravePhone/Data/DataSources/Remote/SecretsManager.swift

import Foundation

/// If you no longer need to retrieve an OpenAI key on-device, you can remove or repurpose this file.
/// For example, store your backend baseURL if you wish to keep "SecretsManager" around:
public enum SecretsManager {
    /// Example: a secure place for your backend base URL if you don't want it hard-coded.
    public static func baseURL() throws -> String {
        guard
            let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
            let plist = NSDictionary(contentsOfFile: filePath),
            let baseURL = plist["CRAVE_BACKEND_BASE_URL"] as? String,
            !baseURL.isEmpty
        else {
            throw SecretsError.missingKey("CRAVE_BACKEND_BASE_URL")
        }
        return baseURL
    }
}

public enum SecretsError: Error, LocalizedError {
    case missingKey(String)
    public var errorDescription: String? {
        switch self {
        case .missingKey(let keyName):
            return "Secrets.plist is missing the '\(keyName)' key or it's empty."
        }
    }
}
