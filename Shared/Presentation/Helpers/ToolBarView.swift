//
//  ToolBarView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/27/24.
//

import SwiftUI

struct ToolBarView: ToolbarContent {
    @Environment(\.colorScheme) var colorScheme
    var didTap: () -> Void
    var placement: ToolbarItemPlacement
    var systemName: String
    
    init(placement: ToolbarItemPlacement, systemName: String, didTap: @escaping () -> Void = {}) {
        self.placement = placement
        self.systemName = systemName
        self.didTap = didTap
    }
    
    var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            Button(action: didTap) {
                Image(systemName: systemName)
                    .font(.headline)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
        }
    }
}
