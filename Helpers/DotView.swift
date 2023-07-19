//
//  DotLoading.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.
//

import SwiftUI

struct DotView: View {
    
    @Binding var scale: CGFloat
    @Binding var opacity: CGFloat
   
    
    
    var body: some View {
        
        Circle()
            .frame(width: 10, height: 10)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .animation(.default, value: 0)
        
    }
    
    
}

#Preview {
    DotView(scale: .constant(0.5), opacity: .constant(0.5))
    
}
