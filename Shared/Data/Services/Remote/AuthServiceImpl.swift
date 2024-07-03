//
//  GoogleAuthService.swift
//  OwnGpt
//
//  Created by Bishalw on 7/2/24.
//

import Foundation
import Combine
import FirebaseAuth

class AuthServiceImpl: AuthService {
   
    
    
    var currentUser: AuthUser?
    
    var isAuthenticated: Bool = false
    
    var authStatePublisher: AnyPublisher<Bool, Never>
    
    
    
    init() {
        
    }
    
    
    func signIn(with provider: AuthProvider) async throws {
        
    }
    
    func signOut() async throws {
        
    }
    
    
}
