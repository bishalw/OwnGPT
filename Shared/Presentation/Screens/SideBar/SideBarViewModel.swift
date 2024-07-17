//
//  SideBarViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 6/24/24.
//

import Foundation
import Combine
protocol SiderBarViewModelSharedStateProvider: ConversationsViewModelSharedStateProvider {
    var selectedConversationPublisher: Published<Conversation?> { get }
}


class SideBarViewModel: ObservableObject {
    let sharedStateProvider: SiderBarViewModelSharedStateProvider
    
    @Published var selectedConversation: Conversation?
    
    init(
        sharedStateProvider: SiderBarViewModelSharedStateProvider
    ) {
        self._selectedConversation = sharedStateProvider.selectedConversationPublisher
        self.sharedStateProvider = sharedStateProvider
    }
    
    
}
