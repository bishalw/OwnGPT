//
//  SignInViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 7/8/24.
//

import Foundation

class SignInViewModel: ObservableObject {
    
    @Published private(set) var state: SigninState = .idle
    @Published var password: String = ""
    @Published var email: String = ""
    
    private let authService: AuthServiceImpl
    
    init(authService: AuthServiceImpl) {
        self.authService = authService
    
    }
    
    @MainActor
      func signInWithEmail() async {
          await signIn(with: .emailPassword)
      }
      
      @MainActor
      func signInWithApple() async {
          await signIn(with: .apple)
      }
      
      @MainActor
      func signInWithGoogle() async {
          await signIn(with: .google)
      }
      
      private func signIn(with provider: AuthProvider) async {
          state = .authenticating(provider)
          
          do {
              let result = try await authService.signIn(
                  with: provider
              )
              state = .success(result)
              if provider == .emailPassword {
                  password = "" // Clear  data
              }
          } catch {
              state = .failure(error)
          }
      }
      
      func resetState() {
          state = .idle
          email = ""
          password = ""
      }
  
}

extension SignInViewModel {
    enum SigninState {
        case idle
        case authenticating(AuthProvider)
        case success(AuthResult)
        case failure(Error)
    }
}


struct AuthResult {
    let user: User
    let provider: AuthProvider
}
enum AuthProvider {
    case apple
    case google
    case emailPassword
}
