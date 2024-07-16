//
//  SignInViewModel.swift
//  OwnGpt
//
//

import Foundation

class SignInViewModel: ObservableObject {
    enum SigninState {
        case idle
        case authenticating(AuthProvider)
        case success(AuthResult)
        case failure(Error)
    }
    
    @Published private(set) var state: SigninState = .idle
    @Published var password: String = ""
    @Published var email: String = ""
    
    private let authService: AuthServiceImpl
    
    init(authService: AuthServiceImpl) {
        self.authService = authService
    }
    
    func signInWithEmail() async {
        await signIn(with: .email(email: email, password: password))
    }
    
    func signInWithApple() async {
        await signIn(with: .apple)
    }
    
    func signInWithGoogle() async {
        await signIn(with: .google)
    }
    
    private func signIn(with provider: AuthProvider) async {
        state = .authenticating(provider)
        
        do {
            let result = try await authService.signIn(with: provider)
            state = .success(result)
            if case .email = provider {
                password = ""
            }
        } catch {
            state = .failure(error)
        }
    }
}


struct AuthResult {
    let user: User
    let token: String
}
enum AuthProvider {
    case apple
    case google
    case email(email: String, password: String)
}
