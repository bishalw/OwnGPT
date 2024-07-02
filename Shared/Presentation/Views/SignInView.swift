//
//  SignInView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/1/24.
//

import Foundation
import SwiftUI

struct SignInView: View {
    let ownGPT = "OwnGPT"
    @State private var visibleCharacters = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    logoView
                    animatedAppNameView
                    Spacer()
                }
                signInButtonsView(geometry: geometry)
            }
        }
        .onAppear(perform: animateText)
    }
    
    private var logoView: some View {
        Image(systemName: "circle.hexagonpath")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .foregroundColor(.white)
            .animation(.easeInOut, value: 20)
    }
    
    private var animatedAppNameView: some View {
        HStack(spacing: 0) {
            ForEach(Array(ownGPT.enumerated()), id: \.offset) { index, character in
                Text(String(character))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .opacity(index < visibleCharacters ? 1 : 0)
            }
        }
    }
    
    private func signInButtonsView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 15) {
            SignInButton(
                action: { /* Handle Apple sign in */ },
                imageName: "apple.logo",
                text: "Sign in with Apple", 
                isSystemImage: true
            )
            
            SignInButton(
                action: { /* Handle Google sign in */ },
                imageName: "Google-Logo",
                text: "Sign in with Google",
                isSystemImage: false
            )
        }
        .position(x: geometry.size.width / 2,
                  y: (geometry.size.height / 2) + (geometry.size.height / 4) + 40)
    }
    
    private func animateText() {
        for index in 0..<ownGPT.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.15) {
                withAnimation(.easeOut(duration: 1).repeatForever()) {
                    visibleCharacters = index + 1
                }
            }
        }
    }
}

struct SignInButton: View {
    let action: () -> Void
    let imageName: String
    let text: String
    let isSystemImage: Bool
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isSystemImage {
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 25)
                        .padding(.trailing, 10)
                } else {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 25)
                        .padding(.trailing, 10)
                }
                Text(text)
                    .frame(width: 150)
            }
            .frame(maxWidth: 200)
            .padding()
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(10)
        }
    }
}
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
