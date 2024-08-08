//
//  ChatsView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/29/23.
//

import SwiftUI

struct ConversationsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    //MARK: Dependency
    @StateObject var vm: ConversationsViewModel
    //MARK: UI State
//    @Binding var selectedConversation: Conversation?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(vm.conversations, id: \.id) { conversation in
                    ConversationItemView(
                        conversation: conversation,
                        isSelected: vm.selectedConversation?.id == conversation.id
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(vm.selectedConversation?.id == conversation.id ? selectionColor : Color.clear)
                    )
                    .contentShape(Rectangle()) // This makes the entire area tappable
                    .onTapGesture {
                        vm.selectConversation(conversation)
                        
                    }
                    .padding(.horizontal, 8)
                    .onAppear(perform: {
                        Log.shared.logger.info("Conversations ItemView appearing")
                    })
                }
            }
        }
    }
    
    private var selectionColor: Color {
        colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6)
    }
}

struct ConversationItemView: View {
    @Environment(\.colorScheme) var colorScheme
    let conversation: Conversation
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "bubble.fill")
                .frame(width: 30, height: 30)
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            Text(conversation.lastMessagePreview)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .frame(height: 56)
        .frame(maxWidth: .infinity)
    }
}
