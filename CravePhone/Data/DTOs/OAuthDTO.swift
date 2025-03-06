// File: OAuthDTO.swift
// PURPOSE: Data models for Google OAuth-specific requests/responses.
// We add CodingKeys to correctly map the JSON keys from the backend.

import Foundation

struct GoogleOAuthRequestDTO: Codable {
    // If your backend expects the key "id_token", we map it here.
    let idToken: String

    enum CodingKeys: String, CodingKey {
        case idToken = "id_token"
    }
}

struct GoogleOAuthResponseDTO: Codable {
    let accessToken: String         // Maps to "access_token"
    let tokenType: String?          // Maps to "token_type"
    let refreshToken: String?       // Maps to "refresh_token"
    let expiresIn: Int?             // Maps to "expires_in"
    let isNewUser: Bool?            // Maps to "is_new_user", if backend provides this info

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case isNewUser = "is_new_user"
    }
}
