//
//  GoogleAuthService.swift
//  OwnGpt
//
//  Created by Bishalw on 7/2/24.
//

import Foundation
import Combine
import FirebaseAuth
import AuthenticationServices
import CryptoKit

class AuthServiceImpl {
    
    var currentUser: AuthUser?
    
    var isAuthenticated: Bool = false
    
    private var authStateSubject = CurrentValueSubject<Bool, Never>(false)

    
    var authStatePublisher: AnyPublisher<Bool, Never> {
        authStateSubject.eraseToAnyPublisher()
    }
    
    init(currentUser: AuthUser?) {
        self.currentUser = currentUser
    }
    
    
    func signIn(with provider: AuthProvider) async throws -> AuthResult {
        switch provider {
        case .apple:
            // MARK: TODO- Apple Auth
            let user = User.init(id: "", name: "", email: "")
            return AuthResult.init(user: user , provider: .apple )
        case .google:
            // MARK: TODO- Google Auth
            let user = User.init(id: "", name: "", email: "")
            return AuthResult.init(user: user , provider: .google )
        case .emailPassword:
            return AuthResult(user: .init(id: "", name: "", email: ""), provider: .emailPassword)
        }
        
    }
    
    
}


enum SignInError: Error {
    case credentialNotFound
    case invalidIdToken
}

struct NonceGenerator {
    static func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 { return }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
}

struct SHA256 {
    static func hash(string: String) -> String {
        let inputData = Data(string.utf8)
        let hashedData = CryptoKit.SHA256.hash(data: inputData)
        return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }
}
