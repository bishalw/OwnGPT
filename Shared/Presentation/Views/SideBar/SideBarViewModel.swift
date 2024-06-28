//
//  SideBarViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 6/24/24.
//

import Foundation
import Combine
protocol SiderBarViewModelSharedProvider {
    var selectedConversationPublisher: Published<Conversation?> { get }
}
class SideBarViewModel: ObservableObject,ConversationsViewModelSharedProvider {
    
    @Published var selectedConversation: Conversation?
    
    var selectedConversationPublisher: Published<Conversation?> {
        self._selectedConversation
    }
    
    
    init(siderBarViewModelSharedProvider:SiderBarViewModelSharedProvider) {
        self._selectedConversation = siderBarViewModelSharedProvider.selectedConversationPublisher
    }
    
    
}
