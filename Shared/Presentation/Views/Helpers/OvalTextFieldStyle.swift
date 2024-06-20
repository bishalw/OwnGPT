//
//  OvalTextFieldStyle.swift
//  OwnGpt
//
//  Created by Bishalw on 7/19/23.
//

import Foundation
import SwiftUI

struct OvalTextFieldStyle: TextFieldStyle {
    @Environment(\.colorScheme) private var colorScheme
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .foregroundColor(colorScheme == .light ? .black : .white)
            .background(LinearGradient(gradient: Gradient(colors: [Color.gray, Color.gray]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(20)
            .shadow(color: .gray, radius: 10)
        }
}

extension TextField {
    func ovalTextFieldStyle() -> some View {
        self.textFieldStyle(OvalTextFieldStyle())
    }
}

