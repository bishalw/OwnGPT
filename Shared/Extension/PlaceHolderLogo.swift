//
//  Animation.swift
//  OwnGpt
//
//  Created by Bishalw on 6/26/24.
//

import Foundation
import SwiftUI

struct PlaceHolderLogo: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "circle.hexagonpath")
                .font(.system(size: 50))
                .foregroundColor(colorScheme == .light ? .black : .white )
                .offset(y: 0)
            Text("Start a new conversation")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)
            Spacer()
        }
    }
}
