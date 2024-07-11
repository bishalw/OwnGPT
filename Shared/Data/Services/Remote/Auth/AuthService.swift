//
//  AuthService.swift
//  OwnGpt
//
//  Created by Bishalw on 7/1/24.
//

import Foundation
import Combine



enum AuthError: Error {
    case invalidCredentials
    case networkError
    case unknownError
}
protocol AuthUser {
    var id: String { get }
    var name: String? { get }
    var email: String? { get }
}


protocol AuthService {
    func signIn(with provider: AuthProvider) async throws -> AuthResult
}

