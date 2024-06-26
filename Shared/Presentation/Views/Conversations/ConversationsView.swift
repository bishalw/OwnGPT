//
//  ChatsView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/29/23.
//

import SwiftUI

struct ConversationsView: View {
    @StateObject var conversationsViewModel : ConversationsViewModel
    @EnvironmentObject var core: Core
    
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(conversationsViewModel.conversations, id: \.id) { chat in
//
                    ConversationItemView(conversation: chat)
                    
                }.onDelete(perform: { indexSet in
                    
                })
            }
            .listStyle(PlainListStyle())
        }
    }
    

}
struct ConversationItemView: View {
    let conversation: Conversation
    
    var body: some View {
        HStack {
            Image(systemName: "message")
            Text(conversation.lastMessagePreview)
        }
    }
}



