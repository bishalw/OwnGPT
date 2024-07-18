//
//  HamburgerButton.swift
//  OwnGpt
//
//  Created by Bishalw on 6/26/24.
//

import SwiftUI
struct HamburgerButton: View {
    @Environment(\.colorScheme) var colorScheme
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
                    VStack(alignment: .leading, spacing: 4) {
                        Rectangle()
                            .fill(colorScheme == .dark ? Color.white : Color.black)
                            .frame(width: 18, height: 2.5)
                            .padding(.bottom, 1)
                            .cornerRadius(1)

                        Rectangle()
                            .fill(colorScheme == .dark ? Color.white : Color.black)
                            .frame(width: 12, height: 2.5)
                            .cornerRadius(1)
                    }
                    .background(Color.clear)  // Ensure the background is not interfering
                }
                Spacer()
            }
            Spacer()
        }
    }
}
#Preview {
    HamburgerButton(showMenu: .constant(true), offset: .constant(0), sidebarWidth: 55)

}
