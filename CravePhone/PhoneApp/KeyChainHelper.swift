//
//  KeychainHelper.swift
//  CravePhone/PhoneApp
//
//  PURPOSE:
//   - Save/load/delete the JWT token from the iOS Keychain.
//   - Provide a one-time convenience method to clear tokens for debug/testing.
//

import Foundation
import Security

struct KeychainHelper {
    static func save(data: Data, service: String, account: String) {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        // Remove any existing entry before adding
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        if status != errSecSuccess {
            print("Error saving to Keychain: \(status)")
        }
    }
    
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
            print("Error loading from Keychain: \(status)")
            return nil
        }
    }
    
    static func delete(service: String, account: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        if status != errSecSuccess && status != errSecItemNotFound {
            print("Error deleting from Keychain: \(status)")
        }
    }
    
    // MARK: - One-Time Clear JWT/Refresh
    static func clearCraveTokensOnce() {
        // Adjust these to match whatever you actually store in Keychain:
        let service = "com.Novamind.CRAVE"
        
        // If you only need to remove JWT token:
        delete(service: service, account: "jwtToken")
        
        // If you also want to remove refresh token:
        // delete(service: service, account: "refreshToken")
        
        print("✅ One-time Keychain cleanup completed.")
    }
}
