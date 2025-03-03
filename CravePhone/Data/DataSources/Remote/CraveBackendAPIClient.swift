//  CraveBackendAPIClient.swift
import Foundation

// Define a custom error enum for API-related errors
public enum APIError: Error, Equatable { // Made public
    case invalidURL
    case invalidResponse
    case networkError(URLError) // Associate the URLError
    case decodingError(Error) // Keep this as a general Error
    case unauthorized
    case serverError(Int)
    case other(String)  // Use a String for a custom message

    public var localizedDescription: String { // Add a localizedDescription
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid server response."
        case .networkError(let urlError):
            return "Network error: \(urlError.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .unauthorized:
            return "Unauthorized (401)."
        case .serverError(let code):
            return "Server error (code \(code))."
        case .other(let message):
            return message
        }
    }

     public static func == (lhs: APIError, rhs: APIError) -> Bool { // Improve Equatable
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL): return true
        case (.invalidResponse, .invalidResponse): return true
        case (.networkError(let lhsError), .networkError(let rhsError)):
            return lhsError.code == rhsError.code // Compare URLError codes
        case (.decodingError, .decodingError): return true // Still general, could improve
        case (.unauthorized, .unauthorized): return true
        case (.serverError(let lhsCode), .serverError(let rhsCode)): return lhsCode == rhsCode
        case (.other(let lhsMsg), .other(let rhsMsg)): return lhsMsg == rhsMsg
        default: return false
        }
    }
}

public class CraveBackendAPIClient { // Made public

    private let baseURLString = "https://crave-mvp-backend-production.up.railway.app"  //  YOUR RAILWAY URL

     public func generateTestToken() async throws -> String { // Made public
        guard let url = URL(string: "\(baseURLString)/api/admin/generate-test-token") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Set a reasonable timeout
        request.timeoutInterval = 10.0

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            print("HTTP Status Code (generateTestToken): \(httpResponse.statusCode)") // Log the status code

            if httpResponse.statusCode == 401 {
                throw APIError.unauthorized
            }

            if httpResponse.statusCode >= 500 {
                throw APIError.serverError(httpResponse.statusCode)
            }


            // Check for successful status code
            guard (200...299).contains(httpResponse.statusCode) else {
              throw APIError.invalidResponse //  Or a more specific error
            }

            //Decode JSON
            do{
                let decodedResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                return decodedResponse.token
            } catch {
                print("JSON Decoding Error (generateTestToken): \(error)")
                throw APIError.decodingError(error) // No change needed here
            }

        } catch {
            print("Networking or other Error (generateTestToken): \(error)")
            // IMPORTANT:  Check if it's a URLError
            if let urlError = error as? URLError {
                throw APIError.networkError(urlError) // Pass the URLError
            } else {
                throw APIError.other("Networking or other Error: \(error.localizedDescription)") // Pass a descriptive message
            }
        }
    }



    public func sendMessage(userQuery: String, authToken: String) async throws -> String {  // Made public, corrected method name
        guard let url = URL(string: "\(baseURLString)/api/v1/chat") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization") // Add the Authorization header!

        let requestBody: [String: Any] = ["user_query": userQuery]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
         request.timeoutInterval = 60.0 // Longer timeout for chat

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            print("HTTP Status Code (sendMessage): \(httpResponse.statusCode)")


            if httpResponse.statusCode == 401 {
                throw APIError.unauthorized
            }

             if httpResponse.statusCode >= 500 {
                    throw APIError.serverError(httpResponse.statusCode)
                }


            guard (200...299).contains(httpResponse.statusCode) else {
                 print("HTTP Status Code: \(httpResponse.statusCode)")
                throw APIError.invalidResponse
            }

            do {
                let decodedResponse = try JSONDecoder().decode(ChatResponse.self, from: data)
                return decodedResponse.response
            } catch {
                print("JSON Decoding Error (sendMessage): \(error)")
                throw APIError.decodingError(error) // No change here
            }


        } catch {
            print("Network or other Error (sendMessage): \(error)")
            // IMPORTANT: Check for URLError
            if let urlError = error as? URLError {
                throw APIError.networkError(urlError)
            } else {
                throw APIError.other("Networking or other Error: \(error.localizedDescription)")
            }
        }
    }
}

// Add these structs to the CraveBackendAPIClient.swift file (or a separate file if you prefer)
public struct TokenResponse: Decodable { // Made public
    public let token: String // Made public
}

public struct ChatResponse: Decodable { // Made public
    public let response: String // Made public //  Adjust this based on your actual backend response.  Could be nested.
}
