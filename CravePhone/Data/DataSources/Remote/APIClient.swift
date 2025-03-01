//
//  APIClient.swift
//  CravePhone
//
//  Description:
//     Handles low-level networking to external APIs (like OpenAI).
//     Injects the secret key from SecretsManager (assumed implemented).
//
//  SOLID / Uncle Bob style:
//    - Single Responsibility: All things networking are contained here.
//    - Dependency Inversion: Higher layers use this via AiChatRepository or UseCase.
//
import Foundation

public final class APIClient {
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Performs an OpenAI Chat request:
    /// - Parameters:
    ///   - prompt: The user’s prompt or message to send to OpenAI.
    ///   - model: e.g., "gpt-4" or "gpt-3.5-turbo".
    /// - Returns: The raw Data returned by the server (JSON).
    public func fetchOpenAIResponse(
        prompt: String,
        model: String = "gpt-4"   // <--- Default to GPT-4
    ) async throws -> Data {
        
        // 1) Build the URL
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            throw APIError.invalidEndpoint
        }
        
        // 2) Create request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // 3) Load OpenAI API key (from Secrets.plist or other secure store).
        //    Implementation detail in SecretsManager assumed.
        let apiKey = try SecretsManager.openAIAPIKey()
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        // 4) Body: specify model and prompt
        let bodyParameters: [String: Any] = [
            "model": model,
            "messages": [
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters)
        
        // 5) Common headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 6) Make the request
        let (data, response) = try await session.data(for: request)
        
        // 7) Validate status code
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode)
        else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw APIError.unexpectedStatusCode(code)
        }
        
        return data
    }
}

// MARK: - Supporting Errors
public enum APIError: Error, LocalizedError {
    case invalidEndpoint
    case unexpectedStatusCode(Int)
    
    public var errorDescription: String? {
        switch self {
        case .invalidEndpoint:
            return "Invalid OpenAI endpoint URL."
        case .unexpectedStatusCode(let code):
            return "Unexpected HTTP status code: \(code)"
        }
    }
}
