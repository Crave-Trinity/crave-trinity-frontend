//
//  AiChatRepositoryImpl.swift
//  CravePhone
//
//  Description:
//    Actual implementation hitting the RAG/AI backend endpoint using APIClient.
//
import Foundation

public final class AiChatRepositoryImpl: AiChatRepositoryProtocol {
    
    private let apiClient: APIClient
    private let baseURL: URL
    
    public init(apiClient: APIClient, baseURL: URL) {
        self.apiClient = apiClient
        self.baseURL = baseURL
    }
    
    public func getAiResponse(for userQuery: String) async throws -> String {
        // For example, the endpoint might be /chat or /rag-query
        let endpoint = "\(baseURL.absoluteString)/chat?query=\(userQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        // Perform request
        let data = try await apiClient.performRequest(endpoint: endpoint)
        
        // Attempt to decode; your API might return JSON with a "response" field
        // For now, let's assume the raw string is the entire response:
        guard let responseString = String(data: data, encoding: .utf8),
              !responseString.isEmpty else {
            throw URLError(.badServerResponse)
        }
        return responseString
    }
}
