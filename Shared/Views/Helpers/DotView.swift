//
//  DotLoading.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.
//

import SwiftUI

struct DotView: View {
    @Binding var scale: CGFloat
    var body: some View {
        Circle()
            .frame(width: 8, height: 8)
            .scaleEffect(scale)
            .opacity(0.5)
        }
}

#Preview {
    DotView(scale: .constant(0.5))
    
}
