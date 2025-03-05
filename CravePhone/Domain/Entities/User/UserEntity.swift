//
//  UserEntity.swift
//  CravePhone/Domain/Entities/User
//
//  PURPOSE: Represents the user model in Swift to match your backend's user.py.
//
//  Adjust the properties to align EXACTLY with the backend user schema.
//
import Foundation

struct UserEntity: Identifiable, Codable {
    let id: Int          // or UUID if your backend uses UUID
    let email: String
    let fullName: String
    let isActive: Bool
    let createdAt: Date?
    let updatedAt: Date?
    
    // Add any other fields your backend returns about the user
    // (avatar, roles, etc.)
}
