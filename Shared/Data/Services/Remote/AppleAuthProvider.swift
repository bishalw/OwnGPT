//
//  AppleAuthProvider.swift
//  OwnGpt
//
//  Created by Bishalw on 7/8/24.
//

import Foundation

class AppleAuthService: AuthServiceProviderProtocol {
    func signIn() async throws -> AuthUser {
        return User(id: "234", name: "bishal", email: "wagle")
    }
}
