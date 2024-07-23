//
//  AppleAuthProvider.swift
//  OwnGpt
//
//

import Foundation
import AuthenticationServices

class AppleAuthStrategy: NSObject, AuthStrategy, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private var continuation: CheckedContinuation<AuthResult, Error>?
    
    func authenticate() async throws -> AuthResult {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?.resume(throwing: AuthError.unknownError)
            return
        }
        
        let userId = appleIDCredential.user
        let fullName = appleIDCredential.fullName
        let email = appleIDCredential.email ?? ""
        let identityToken = appleIDCredential.identityToken
        _ = appleIDCredential.authorizationCode
        
        let authResult = AuthResult(
            user: User(id: userId, name: fullName?.givenName ?? "Apple User", email: email),
            token: String(data: identityToken ?? Data(), encoding: .utf8) ?? ""
        )
        
        continuation?.resume(returning: authResult)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: error)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            
            return UIWindow()
        }
        return window
    }
}


struct Todo: Identifiable {
    let id = UUID()
    var title: String
    var dates: [Date]
}

class TodoViewModel: ObservableObject {
    enum DateSelectedState {
        case notSelected
        case selected
        
        var rawValue: Bool {
            switch self {
            case .notSelected: return false
            case .selected:  return true
            }
        }
    }
    @Published var todos: [Todo] = []
    @Published var selectedDates: [Date] = []
    @Published var isSelectingDates = false // this
    @Published var dateState: DateSelectedState = .notSelected // or this
    
}
