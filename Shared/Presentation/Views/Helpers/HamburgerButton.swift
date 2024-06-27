//
//  HamburgerButton.swift
//  OwnGpt
//
//  Created by Bishalw on 6/26/24.
//

import SwiftUI

struct HamburgerButton: View {
    @Binding var showMenu: Bool
    @Binding var offset: CGFloat
    let sidebarWidth: CGFloat
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation(.easeOut(duration: 0.3)) {
                        if offset == 0 {
                            offset = sidebarWidth
                            showMenu = true
                        } else {
                            offset = 0
                            showMenu = false
                        }
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .imageScale(.large)
                }
                Spacer()
            }
            Spacer()
        }
    }
}
#Preview {
//    HamburgerButton()
    EmptyView()
}
