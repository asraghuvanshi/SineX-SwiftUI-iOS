//
//  SessionService.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 26/06/26.
//


import Foundation
import Security


final class SessionService {

    static let shared = SessionService()

    private let service = "com.softwaredev.meet.app"
    private let account = "authToken"

    private init() {}

    var hasValidToken: Bool {
        token != nil
    }

    var token: String? {
        guard let data = readKeychain(), let token = String(data: data, encoding: .utf8) else {
            return nil
        }
        return token
    }

    func save(token: String) {
        let data = Data(token.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)

        var attributes = query
        attributes[kSecValueData as String] = data
        SecItemAdd(attributes as CFDictionary, nil)
    }

    func clear() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }

    private func readKeychain() -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess else { return nil }
        return result as? Data
    }
}
