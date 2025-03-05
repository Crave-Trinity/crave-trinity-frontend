//
//  OAuthDTO.swift
//  CravePhone/Data/DTOs
//
//  PURPOSE: Data models for Google OAuth-specific requests/responses.
//
import Foundation

struct GoogleOAuthRequestDTO: Codable {
    let idToken: String
}

struct GoogleOAuthResponseDTO: Codable {
    let accessToken: String
    let tokenType: String?
    let refreshToken: String?
    let expiresIn: Int?
    let isNewUser: Bool? // If backend returns something about new vs. existing user
}
