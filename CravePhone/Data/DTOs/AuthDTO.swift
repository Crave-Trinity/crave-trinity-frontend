// File: AuthDTO.swift
// PURPOSE: Generic authentication responses & requests (JWT, tokens, etc.)
// This version uses CodingKeys to map backend snake_case keys to our camelCase properties.

import Foundation

struct AuthRequestDTO: Codable {
    let email: String
    let password: String
}

// Updated AuthResponseDTO with CodingKeys to match the backend response.
// The backend sends "access_token", "token_type", and (for Google OAuth) "user_id".
struct AuthResponseDTO: Codable {
    let accessToken: String         // Maps to "access_token"
    let tokenType: String?          // Maps to "token_type"
    let userId: Int?                // Maps to "user_id" (only available in Google OAuth flow)
    let refreshToken: String?       // Optional: if backend returns a refresh token
    let expiresIn: Int?             // Optional: number of seconds until expiry

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case userId = "user_id"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
    }
}
