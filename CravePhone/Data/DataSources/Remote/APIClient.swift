//=================================================================
// 1) APIClient.swift
//   CravePhone/Data/DataSources/Remote/APIClient.swift
//=================================================================

import Foundation

// Define the structure for the OpenAI API request (Chat Completions API - /v1/chat/completions)
public struct OpenAICompletionsRequest: Encodable { // Changed to public
    public let model: String
    public let messages: [[String: String]] // Array of messages for context
    public let max_tokens: Int? // Optional, but good to control response length
    public let temperature: Double? // Optional, control randomness
    public  let n: Int?
    public let stop: [String]?
}

// Define the structure for the OpenAI API response (Chat Completions API)
public struct OpenAICompletionsResponse: Decodable { // Changed to public
    public struct Choice: Decodable {
        public struct Message: Decodable {
            public  let role: String
            public let content: String
        }
        public let message: Message
        public let finish_reason: String? // Optional, explains why the generation stopped
    }
    public let choices: [Choice]
    // let usage: Usage // You might want to capture usage data (tokens used, etc.)
}


public final class APIClient {

    private let session: URLSession
    private let baseURL = "https://api.openai.com/v1" // Base URL for OpenAI API

    public init(session: URLSession = .shared) {
        self.session = session
    }

    /// Performs an OpenAI Chat request using the prompt & model.
    public func fetchOpenAIResponse(
        prompt: String,
        model: String = "gpt-3.5-turbo" // Use gpt-3.5-turbo for chat
    ) async throws -> OpenAICompletionsResponse { // Return the decoded response

        guard let url = URL(string: baseURL + "/chat/completions") else { // Use chat completions endpoint
            throw APIError.invalidEndpoint
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let apiKey = try SecretsManager.openAIAPIKey()
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Construct the messages array for the request body. Include a system message.
        let messages = [
            ["role": "system", "content": "You are a helpful assistant that helps people manage their cravings."],  // System message
            ["role": "user", "content": prompt]
        ]
        
        //Use the request Body, cleaner
        let requestBody = OpenAICompletionsRequest(
              model: model,
              messages: messages, // Pass the constructed messages
              max_tokens: 150,  // Control the response length
              temperature: 0.7,  // Control creativity/randomness
              n: 1,          // Usually, one response is enough
              stop: ["\nUser:", "\nAI:"]
        )

        request.httpBody = try JSONEncoder().encode(requestBody)

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode)
        else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw APIError.unexpectedStatusCode(code)
        }

        // Decode the JSON response *before* returning.  This is crucial.
        do {
            let decodedResponse = try JSONDecoder().decode(OpenAICompletionsResponse.self, from: data)
            return decodedResponse
        } catch {
            print("Decoding error: \(error)") // Log the actual decoding error
            throw APIError.decodingError(error) // Throw a specific decoding error
        }
    }

    // MARK: - Supporting Errors
    public enum APIError: Error, LocalizedError {
        case invalidEndpoint
        case unexpectedStatusCode(Int)
        case decodingError(Error) // Add a case for decoding errors

        public var errorDescription: String? {
            switch self {
            case .invalidEndpoint:
                return "Invalid OpenAI endpoint URL."
            case .unexpectedStatusCode(let code):
                return "Unexpected HTTP status code: \(code)"
            case .decodingError(let error):
                return "Failed to decode response: \(error.localizedDescription)" // Provide error details
            }
        }
    }
}
