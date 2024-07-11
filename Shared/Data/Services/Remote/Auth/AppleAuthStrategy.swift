//
//  AppleAuthProvider.swift
//  OwnGpt
//
//  Created by Bishalw on 7/8/24.
//

import Foundation

class AppleAuthStrategy: AuthStrategy {
    func authenticate() async throws -> AuthResult {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        let user = User(id: "apple_456", name: "Apple User", email: "apple_user@example.com")
        let token = "sample_apple_jwt_token"
        return AuthResult(user: user, token: token)
    }
}
