//
//  FirebaseAuthService.swift
//  OwnGpt
//
//

import Foundation
import FirebaseAuth


protocol AuthStrategy {
    func authenticate() async throws -> AuthResult
}

class EmailAuthStrategy: AuthStrategy {
    let email: String
    let password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    func authenticate() async throws -> AuthResult {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        if email == "test@example.com" && password == "password" {
            let user = User(id: "email_123", name: "Email User", email: email)
            let token = "sample_jwt_token"
            return AuthResult(user: user, token: token)
        } else {
            throw AuthError.invalidCredentials
        }
    }
}
