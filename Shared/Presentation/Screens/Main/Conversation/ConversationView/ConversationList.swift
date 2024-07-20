//
//  ChatListView.swift
//  OwnGpt
//
//

import SwiftUI

struct ConversationList: View {
    @Environment(\.colorScheme) var colorScheme
    var messages: [Message]
    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(messages) { message in
                MessageView(message: message)
            }
        }
    }
}



