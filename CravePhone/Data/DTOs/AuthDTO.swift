//
//  AuthDTO.swift
//  CravePhone/Data/DTOs
//
//  PURPOSE: Generic authentication responses & requests (JWT, tokens, etc.)
//
import Foundation

struct AuthRequestDTO: Codable {
    let email: String
    let password: String
}

struct AuthResponseDTO: Codable {
    let accessToken: String   // Or "token" if that’s the exact JSON key in the backend
    let tokenType: String?    // e.g. "Bearer"
    let refreshToken: String? // optional if your backend issues refresh tokens
    let expiresIn: Int?       // optional: number of seconds
}
