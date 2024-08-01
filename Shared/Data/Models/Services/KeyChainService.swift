//
//  KeyChainService.swift
//  OwnGpt
//
//  Created by Bishalw on 7/20/24.
//

import Foundation
import Combine
enum KeychainError: Error {
    case saveFailed(status: OSStatus)
    case updateFailed(status: OSStatus)
    case retrieveFailed(status: OSStatus)
    case deleteFailed(status: OSStatus)
    case unexpectedItemType
}

protocol KeyChainService {
    func save<T: Encodable>(_ item: T, for key: String ) async throws
    func retrieve<T: Decodable>(_ key: String) async throws -> T?
    func delete(for key: String) async throws
    
}

class KeyChainServiceImpl: KeyChainService  {

    private let dataEncoder: JSONEncoder
    private let dataDecoder: JSONDecoder
    private let service: String

    
    init(
        dataEncoder: JSONEncoder = JSONEncoder(),
        dataDecoder: JSONDecoder = JSONDecoder(),
        service: String = Bundle.main.bundleIdentifier ?? "com.OwnGPT.identifier"

    ){
        self.dataEncoder = dataEncoder
        self.dataDecoder = dataDecoder
        self.service = service
    }
   
    
    func save<T: Encodable>(_ item: T, for key: String) throws {
        let data = try dataEncoder.encode(item)
        Log.shared.logger.info("Attempting item for key \(key): \(item)")

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrService as String: service,
            kSecAttrSynchronizable as String: kSecAttrSynchronizableAny
        ]
        // Add
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            // Item already exists, so update it
            let updateQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: key,
                kSecAttrSynchronizable as String: kSecAttrSynchronizableAny
            ]
            
            let attributes: [String: Any] = [kSecValueData as String: data]
            // update the data
            let updateStatus = SecItemUpdate(updateQuery as CFDictionary, attributes as CFDictionary)
            guard updateStatus == errSecSuccess else {
                throw KeychainError.saveFailed(status: updateStatus)
            }
            Log.shared.logger.info("Item updated successfully for key \(key)")
        } else if status != errSecSuccess {
            throw KeychainError.saveFailed(status: status)
        }
        Log.shared.logger.info("Item saved successfully for key \(key)")

        
    }
    func retrieve<T: Decodable>(_ key: String) throws -> T? {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecReturnData as String: true,
                kSecMatchLimit as String: kSecMatchLimitOne,
                kSecAttrService as String: service,
                kSecAttrSynchronizable as String: kSecAttrSynchronizableAny
            ]
            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)
            
        switch status {
               case errSecSuccess:
                   guard let data = item as? Data else {
                       throw KeychainError.unexpectedItemType
                   }
                   let decodedItem = try dataDecoder.decode(T.self, from: data)
                   Log.shared.logger.info("Retrieved item for key \(key): \(decodedItem)")
                   return decodedItem
               case errSecItemNotFound:
                   Log.shared.logger.info("No item found for key \(key)")
                   return nil
               default:
                   throw KeychainError.retrieveFailed(status: status)
               }
        }
    func delete(for key: String) async throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: service
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



