//
//  ChatListView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/26/23.
//

import SwiftUI

struct MesssageList: View {
    @Environment(\.colorScheme) var colorScheme
    var messages: [Message]
    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(messages) { message in
                MessageRow(message: message)
            }
        }
    }
}



