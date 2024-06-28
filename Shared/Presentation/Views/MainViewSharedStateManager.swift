//
//  MainViewSharedStateManager.swift
//  OwnGpt
//
//  Created by Bishalw on 6/28/24.
//

import Foundation
class MainViewSharedStateManager: ObservableObject, ConversationsViewModelSharedProvider,
    SiderBarViewModelSharedProvider,
    ConversationViewModelSharedProvider
{
    
    @Published var selectedConversation: Conversation?
    
    var selectedConversationPublisher: Published<Conversation?> {
        self._selectedConversation
    }
    
    init() {}
}
