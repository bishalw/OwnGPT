//
//  Animation.swift
//  OwnGpt
//
//  Created by Bishalw on 6/26/24.
//

import Foundation
import SwiftUI

struct PlaceHolderLogo: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "circle.hexagonpath")
                .font(.system(size: 50))
                .foregroundColor(colorScheme == .light ? .black : .white )
                .phaseAnimator(AnimationPhase.allCases) { content,
                    phase in
                    content
                        .scaleEffect(phase.scale)
                } animation: { phase in
                    phase.animation
                    
                }
                .offset(y: 0)
            Text("Start a new conversation")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)
            Spacer()
        }
    }
}
enum AnimationPhase: CaseIterable {
     case beginning, middle, end
    

    var scale: Double {
        switch self {
        case .beginning, .end: 1.0
        case .middle: 1.5
            
        }
    }
    
    var animation: Animation {
        switch self {
        case .beginning, .end: .bouncy(duration: 0.4)
        case .middle: .easeInOut(duration: 0.9).repeatForever(autoreverses: true)
        }
    }
}
