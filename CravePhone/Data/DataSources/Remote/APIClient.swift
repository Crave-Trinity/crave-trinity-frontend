//
//  APIClient.swift
//  CravePhone/Data/DataSources/Remote
//
//  GOF/SOLID EXPLANATION:
//   - Single Responsibility: Only handles networking to OpenAI.
//   - Open/Closed: Extended for more endpoints without changing core logic.
//   - Dependency Inversion: Higher layers depend on the protocol, not concrete impl.
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

// The structure matches the OpenAI Chat Completion response
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
    private let baseURL = "https://api.openai.com/v1" // Chat Completions Endpoint
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Performs a Chat Completion request to OpenAI using the user prompt.
    public func fetchOpenAIResponse(
        prompt: String,
        model: String = "gpt-3.5-turbo"
    ) async throws -> OpenAICompletionsResponse {
        
        guard let url = URL(string: baseURL + "/chat/completions") else {
            throw APIError.invalidEndpoint
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Grab your API key (ensure SecretsManager is properly configured)
        let apiKey = try SecretsManager.openAIAPIKey()
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // System + user messages. The system message shapes the AI’s overall behavior.
        let messages: [[String : String]] = [
            [
                "role": "system",
                "content": """
                You are Cravey, a large language model (LLM) that transforms text into math.
                You cannot provide medical diagnoses, advice, or management. At all times, 
                remind users that you are purely informational and that they should consult 
                a healthcare professional for any personal medical concerns.
                """
            ],
            [
                "role": "user",
                "content": prompt
            ]
        ]
        
        // Body: includes your model, messages, and other parameters
        let requestBody = OpenAICompletionsRequest(
            model: model,
            messages: messages,
            max_tokens: 150,
            temperature: 0.7,
            n: 1,
            stop: ["\nUser:", "\nAI:"]
        )
        
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw APIError.unexpectedStatusCode(code)
        }
        
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
