//  CraveBackendAPIClient.swift
//  CravePhone/Data/DataSources/Remote
//

import Foundation

// Define a custom error enum for API-related errors
public enum APIError: Error, Equatable { // Made public
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case decodingError(Error)
    case unauthorized // Add an explicit unauthorized case
    case serverError(Int)
    case other(Error)

     public static func == (lhs: APIError, rhs: APIError) -> Bool { // Made public
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL): return true
        case (.invalidResponse, .invalidResponse): return true
        case (.networkError(_), .networkError(_)): return true // You might want more specific comparison here
        case (.decodingError(_), .decodingError(_)): return true // You might want more specific comparison here
        case (.unauthorized, .unauthorized): return true
        case (.serverError(let lhsCode), .serverError(let rhsCode)): return lhsCode == rhsCode
        case (.other(_), .other(_)): return true  // This is a simplification, consider comparing the underlying errors.
        default: return false
        }
    }
}

public class CraveBackendAPIClient { // Made public

    private let baseURLString = "https://crave-mvp-backend-production.up.railway.app"  //  YOUR RAILWAY URL - VERY IMPORTANT

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
                throw APIError.unauthorized // Throw specific unauthorized error
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
                let decodedResponse = try JSONDecoder().decode(TokenResponse.self, from: data) // Use the TokenResponse struct
                return decodedResponse.token
            } catch {
                print("JSON Decoding Error (generateTestToken): \(error)") // More detailed error
                throw APIError.decodingError(error)
            }

        } catch {
            print("Networking or other Error (generateTestToken): \(error)") // Catch URLSession errors
            throw APIError.networkError(error) // Wrap as a network error
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
            let (data, response) = try await URLSession.shared.data(for: request)  // Use URLSession.shared.data(for:)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            print("HTTP Status Code (sendMessage): \(httpResponse.statusCode)") // Log status code, corrected method name


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
                let decodedResponse = try JSONDecoder().decode(ChatResponse.self, from: data) // Use ChatResponse struct
                return decodedResponse.response //  Adjust based on your actual backend response
            } catch {
                print("JSON Decoding Error (sendMessage): \(error)") // Log decoding errors, corrected method name
                throw APIError.decodingError(error)
            }


        } catch {
            print("Network or other Error (sendMessage): \(error)")  // Corrected method name
            throw APIError.networkError(error) // Consistent error wrapping
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
