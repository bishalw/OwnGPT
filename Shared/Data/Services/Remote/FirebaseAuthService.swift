//
//  FirebaseAuthService.swift
//  OwnGpt
//
//  Created by Bishalw on 7/2/24.
//

import Foundation
import FirebaseAuth

protocol AuthServiceProviderProtocol  {
    func signIn() async throws -> AuthUser
}
class FireBaseAuthProvider: AuthServiceProviderProtocol {
    func signIn() async throws -> AuthUser {
        
        return User(id: "123", name: "bishal", email: "wagle@")
    }
    
}

class AppleAuthProvider: AuthServiceProviderProtocol {
    func signIn() async throws -> AuthUser {
        return User(id: "234", name: "bishal", email: "wagle")
    }
}
