//
//  LoadingView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.
//

import SwiftUI

struct DotLoadingView: View {
    
    @State var scale0: CGFloat = 0.0
    @State var scale1: CGFloat = 0.0
    @State var scale2: CGFloat = 0.0
    
    @State var opacity0: CGFloat = 0.5
    @State var opacity1: CGFloat = 0.5
    @State var opacity2: CGFloat = 0.5
    
    let animation = Animation.easeInOut.speed(0.5).repeatForever(autoreverses: true)
    
    var body: some View {
        HStack {
            DotView(scale: $scale0, opacity: $opacity0)
            DotView(scale: $scale1, opacity: $opacity1)
            DotView(scale: $scale2, opacity: $opacity2)
        }
        .onAppear{
                    scheduleAnimation(scale: $scale0, opacity: $opacity0, delay: 0.0)
                    scheduleAnimation(scale: $scale1, opacity: $opacity1, delay: 0.2)
                    scheduleAnimation(scale: $scale2, opacity: $opacity2, delay: 0.4)
                }
    }
    func scheduleAnimation(scale: Binding<CGFloat>, opacity: Binding<CGFloat>,delay: TimeInterval) {
         let timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: true) { _ in
             withAnimation(self.animation) {
                 scale.wrappedValue = 1
                 opacity.wrappedValue = 1
             }
         }
         timer.tolerance = 1
     }
}

#Preview {
    DotLoadingView()
}
