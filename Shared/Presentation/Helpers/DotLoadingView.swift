//
//  LoadingView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.
//

import SwiftUI
import UIKit

struct DotLoadingView: View {
    @State private var scales: [CGFloat] = [1, 1, 1]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                DotView()
                    .scaleEffect(scales[index])
            }
        }
        .onAppear {
            for index in 0..<3 {
                withAnimation(
                    .easeInOut(duration: 0.5)
                        .repeatForever(autoreverses: true)
                        .delay(0.2 * Double(index))
                ) {
                    scales[index] = 0.5 //  target scale for each dot
                }
            }
        }
    }
}

#Preview {
    DotLoadingView()
}

