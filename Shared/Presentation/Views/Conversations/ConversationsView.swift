//
//  ChatsView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/29/23.
//

import SwiftUI

struct ConversationsView: View {
    @StateObject var conversationsViewModel: ConversationsViewModel
    @EnvironmentObject var core: Core
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(conversationsViewModel.conversations, id: \.id) { conversation in
                    ConversationItemView(conversation: conversation)
                        .background(Color(UIColor.systemBackground))
                    Divider()
                }
            }
        }
        .navigationTitle("Conversations")
    }
}

struct ConversationItemView: View {
    let conversation: Conversation
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "bubble.fill")
                .frame(width: 30, height: 30)
                .foregroundColor(.blue)
            
            Text(conversation.lastMessagePreview)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .frame(height: 56)
    }
}
