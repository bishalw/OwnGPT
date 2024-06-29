//
//  Extension+Color.swift
//  OwnGpt
//
//  Created by Bishalw on 12/9/23.
//

import Foundation
import SwiftUI
extension Color {
    static let notLight = Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 0.5)
    
}
extension Color {
    static let plusButtonDark = Color(.init(gray: 0.1, alpha: 1))
    static let plusButtonLight = Color(.init(gray: 0.8, alpha: 1))
}

extension Color {
    static let messageInputDark = Color(.white)
    static let messageInputLight = Color(.black)
}

extension Color {
    static let darkBackground = Color.black
    static let lightBackground = Color.white
    static let darkForeground = Color.white
    static let lightForeground = Color.black
    static let disabledForeground = Color.gray
    static let disabledBackground = Color.gray.opacity(0.5)
}
