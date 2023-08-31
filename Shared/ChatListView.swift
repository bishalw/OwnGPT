//
//  ChatListView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/26/23.
//

import SwiftUI

struct ChatListView: View {
    @Environment(\.colorScheme) var colorScheme
    var messages: [Message]
    var retryCallback: (Message) -> ()
    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(messages) { message in
                ChatRowView(message: message) { message in
                    retryCallback(message)
                }
            }
        }
    }
}



