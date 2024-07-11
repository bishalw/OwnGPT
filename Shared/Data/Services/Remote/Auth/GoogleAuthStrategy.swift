//
//  GoogleAuthStrategy.swift
//  OwnGpt
//
//  Created by Bishalw on 7/10/24.
//

import Foundation

class GoogleAuthStrategy: AuthStrategy {
    func authenticate() async throws -> AuthResult {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        let user = User(id: "google_789", name: "Google User", email: "google_user@example.com")
        let token = "sample_google_jwt_token"
        return AuthResult(user: user, token: token)
    }
}
