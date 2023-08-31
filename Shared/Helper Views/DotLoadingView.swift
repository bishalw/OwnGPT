//
//  LoadingView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.
//

import SwiftUI
import UIKit


struct DotLoadingView: View {
    
    @State private var scale1: CGFloat = 1.0
    @State private var scale2: CGFloat = 1.0
    @State private var scale3: CGFloat = 1.0

    var body: some View {
        Group {
            HStack {
                
                DotView(scale: $scale1)
                
                DotView(scale: $scale2)
                
                DotView(scale: $scale3)
                
            }
        }
        .onAppear {
            withAnimation(Animation.easeOut(duration: 0.5).repeatForever(autoreverses: true)) {
                scale1 = 0.5
            }
            
            withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(0.2)) {
                scale2 = 0.5
            }
            
            withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(0.4)) {
                scale3 = 0.5
            }
        }
    }
}

#Preview {
    DotLoadingView()
}
