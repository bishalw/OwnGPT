//
//  AuthService.swift
//  OwnGpt
//
//  Created by Bishalw on 7/1/24.
//

import Foundation
import Combine


enum AuthError: Error {
    case signInFailed(String)
    case signOutFailed(String)
    case notAuthenticated
}

protocol AuthUser {
    var id: String { get }
    var name: String? { get }
    var email: String? { get }
}


protocol AuthService {
    var currentUser: AuthUser? { get }
    var isAuthenticated: Bool { get }
    var authStatePublisher: AnyPublisher<Bool , Never> { get }
    func signIn(with provider: AuthProvider) async throws
    func signOut() async throws
    
}

