//
//  CircularLogoView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/1/24.
//

import SwiftUI

struct CircularLogoView: View {
    let circleColor: Color
    let diameter: CGFloat
    @Binding var isExpanded: Bool
    @State private var rotation: Double = 0
       
    
    var body: some View {
        ZStack {
            ForEach(0..<6) { index in
                ZStack {
                    // Outer circle
                    Circle()
                        .fill(circleColor)
                        .frame(width: diameter / 3, height: diameter / 3)
                    
                    // Inner circle
                    Circle()
                        .fill(Color.black)
                        .frame(width: diameter / 3, height: diameter / 6)
                }
                .offset(offset(for: index, in: diameter))
                .opacity(isExpanded ? 1 : 0)
                .scaleEffect(isExpanded ? 1 : 0.1)
            }
            
            // Central circle (visible when retracted)
            ZStack {
                Circle()
                    .fill(circleColor)
                    .frame(width: diameter / 3, height: diameter / 3)
                    .opacity(isExpanded ? 0 : 1)
                    .scaleEffect(isExpanded ? 0.1 : 1)
                Circle()
                    .fill(Color.black)
                    .frame(width: diameter / 3, height: diameter / 6)
                    .opacity(isExpanded ? 0 : 1)
                    .scaleEffect(isExpanded ? 0.1 : 1)
            }
            
        }
        .frame(width: diameter, height: diameter)
        .rotationEffect(.degrees(rotation))
        .onChange(of: isExpanded) { _ , expanded in
                    if !expanded {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            rotation = 360
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(.easeInOut(duration: 1)) {
                                rotation = 0
                            }
                        }
                    } else {
                        rotation = 0
                    }
                }
        .animation(.easeInOut(duration: 0.5), value: isExpanded)
    }
    
    private func offset(for index: Int, in diameter: CGFloat) -> CGSize {
        let angle = Double(index) * (360.0 / 6.0)
        let radian = angle * .pi / 180
        let radius = isExpanded ? diameter / 2 - diameter / 8 : 0
        return CGSize(
            width: CGFloat(cos(radian)) * radius,
            height: CGFloat(sin(radian)) * radius
        )
    }
}
struct CircularLogoView_Previews: PreviewProvider {
    static var previews: some View {
        CircularLogoView(circleColor: .blue, diameter: 200, isExpanded: .constant(true))
            .previewLayout(.sizeThatFits)
            .padding()
            
    }
}

