//
//  KeyChainService.swift
//  OwnGpt
//
//  Created by Bishalw on 7/20/24.
//

import Foundation

enum KeychainError: Error {
    case saveFailed(status: OSStatus)
    case updateFailed(status: OSStatus)
    case retrieveFailed(status: OSStatus)
    case deleteFailed(status: OSStatus)
    case unexpectedItemType
}

enum ServiceKey: String {
    case openAiAPIKey = "com.OwnGPT.OpenAiAPIkey"
}
struct APIKey{
    var value: String
    let serviceKey: ServiceKey
    
}
protocol KeyChainService {
    func save<T: Encodable>(_ item: T, for key: String ) async throws
    func retrieve<T: Decodable>(_ key: String) async throws -> T?
    func delete(for key: String) async throws
    
}

class KeyChainServiceImpl: KeyChainService  {

    private let dataEncoder: JSONEncoder
    private let dataDecoder: JSONDecoder
    
    init(dataEncoder: JSONEncoder = JSONEncoder(), dataDecoder: JSONDecoder = JSONDecoder()){
        self.dataEncoder = dataEncoder
        self.dataDecoder = dataDecoder
    }
   
    func save<T: Encodable>(_ item: T, for key: String) throws {
        let data = try dataEncoder.encode(item)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrSynchronizable as String: true
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            // Item already exists, so update it
            let updateQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecAttrSynchronizable as String: true
            ]
            
            let attributes: [String: Any] = [
                kSecValueData as String: data
            ]
            
            let updateStatus = SecItemUpdate(updateQuery as CFDictionary, attributes as CFDictionary)
            guard updateStatus == errSecSuccess else {
                throw KeychainError.saveFailed(status: updateStatus)
            }
        } else if status != errSecSuccess {
            throw KeychainError.saveFailed(status: status)
        }
    }
    
    func retrieve<T: Decodable>(_ key: String) throws -> T? {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecReturnData as String: true,
                kSecMatchLimit as String: kSecMatchLimitOne
            ]
            
            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)
            
            switch status {
            case errSecSuccess:
                guard let data = item as? Data else {
                    throw KeychainError.unexpectedItemType
                }
                return try dataDecoder.decode(T.self, from: data)
            case errSecItemNotFound:
                return nil
            default:
                throw KeychainError.retrieveFailed(status: status)
            }
        }
    func delete(for key: String) async throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        switch status {
        case errSecSuccess, errSecItemNotFound:
            return
        default:
            throw KeychainError.deleteFailed(status: status)
        }
        
    }
}

