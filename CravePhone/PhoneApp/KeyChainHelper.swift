// File: KeychainHelper.swift
// PURPOSE: Provides a simple facade for storing, loading, and deleting JWT tokens
//          (and optionally refresh tokens) from the iOS Keychain.
// DESIGN: Single Responsibility, Facade Pattern, clean and testable.
import Foundation
import Security

struct KeychainHelper {
    
    // MARK: - Save Token
    static func save(data: Data, service: String, account: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly, // Removed on uninstall
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: data
        ] as CFDictionary
        
        // Remove any existing token before saving
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        if status != errSecSuccess {
            print("❌ [Keychain] Error saving item for \(account): \(status)")
        } else {
            print("✅ [Keychain] Successfully saved item for \(account).")
        }
    }
    
    // MARK: - Load Token
    static func load(service: String, account: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        if status == errSecSuccess {
            return result as? Data
        } else {
            if status != errSecItemNotFound {
                print("❌ [Keychain] Error loading item for \(account): \(status)")
            }
            return nil
        }
    }
    
    // MARK: - Delete Token
    static func delete(service: String, account: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        if status != errSecSuccess && status != errSecItemNotFound {
            print("❌ [Keychain] Error deleting item for \(account): \(status)")
        } else {
            print("✅ [Keychain] Successfully deleted item for \(account).")
        }
    }
    
    // MARK: - Clear All Tokens (for testing)
    static func clearCraveTokensOnce() {
        let service = "com.crave.app" // Must match usage in AuthRepositoryImpl & AiChatUseCase
        delete(service: service, account: "authToken")
        delete(service: service, account: "refreshToken")
        print("✅ [Keychain] One-time token cleanup completed.")
    }
}
