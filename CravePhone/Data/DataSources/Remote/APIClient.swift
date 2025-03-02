//
//  APIClient.swift
//  CravePhone/Data/DataSources/Remote
//
//  GOF/SOLID NOTES:
//   - Single Responsibility: Only handles networking calls to OpenAI.
//   - Dependency Inversion: Higher layers reference this via protocols, not concrete classes.
//   - Open/Closed: We can add new parameters (e.g. temperature, max_tokens) without breaking existing code.
//
import Foundation

public struct OpenAICompletionsRequest: Encodable {
    public let model: String
    public let messages: [[String: String]]
    public let max_tokens: Int?
    public let temperature: Double?
    public let n: Int?
    public let stop: [String]?
}

// Matches the structure of the OpenAI Chat Completion response
public struct OpenAICompletionsResponse: Decodable {
    public struct Choice: Decodable {
        public struct Message: Decodable {
            public let role: String
            public let content: String
        }
        public let message: Message
        public let finish_reason: String?
    }
    public let choices: [Choice]
}

public final class APIClient {
    
    private let session: URLSession
    // The base path for Chat Completions
    private let baseURL = "https://api.openai.com/v1"
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Communicates with OpenAI's Chat Completions API to get an AI-generated response
    public func fetchOpenAIResponse(
        prompt: String,
        model: String = "gpt-3.5-turbo"
    ) async throws -> OpenAICompletionsResponse {
        
        // 1) Construct the URL for the chat completions endpoint
        guard let url = URL(string: baseURL + "/chat/completions") else {
            throw APIError.invalidEndpoint
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // 2) Grab your API key from SecretsManager
        let apiKey = try SecretsManager.openAIAPIKey()
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 3) Provide a system message that merges disclaimers + cravings focus
        let messages: [[String : String]] = [
            [
                "role": "system",
                "content": """
                You are Cravey, a large language model specializing in cravings-related conversations. 
                However, you do NOT provide medical diagnoses or direct treatment advice. 
                You must always disclaim that you’re purely informational and that users should 
                consult healthcare professionals for personal medical concerns.
                """
            ],
            [
                "role": "user",
                "content": prompt
            ]
        ]
        
        // 4) Build the request body
        let requestBody = OpenAICompletionsRequest(
            model: model,
            messages: messages,
            max_tokens: 150,
            temperature: 0.7,
            n: 1,
            stop: ["\nUser:", "\nAI:"]
        )
        
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        // 5) Execute the request
        let (data, response) = try await session.data(for: request)
        
        // 6) Validate status code
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw APIError.unexpectedStatusCode(code)
        }
        
        // 7) Decode JSON into OpenAICompletionsResponse
        do {
            let decoded = try JSONDecoder().decode(OpenAICompletionsResponse.self, from: data)
            return decoded
        } catch {
            print("Decoding error: \(error)")
            throw APIError.decodingError(error)
        }
    }
}

// MARK: - API Errors
extension APIClient {
    public enum APIError: Error, LocalizedError {
        case invalidEndpoint
        case unexpectedStatusCode(Int)
        case decodingError(Error)
        
        public var errorDescription: String? {
            switch self {
            case .invalidEndpoint:
                return "Invalid endpoint for OpenAI."
            case .unexpectedStatusCode(let code):
                return "Unexpected HTTP status code: \(code)"
            case .decodingError(let error):
                return "Failed to decode OpenAI response: \(error.localizedDescription)"
            }
        }
    }
}
