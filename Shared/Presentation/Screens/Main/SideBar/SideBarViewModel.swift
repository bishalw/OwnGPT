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

protocol SideBarViewModel: ObservableObject {
    var selectedConversation: Conversation? { get set }
    var sharedStateProvider: SiderBarViewModelSharedStateProvider { get }
}

class SideBarViewModelImpl: SideBarViewModel {
    
    let sharedStateProvider: SiderBarViewModelSharedStateProvider
    @Published var selectedConversation: Conversation?
    
    init(
        sharedStateProvider: SiderBarViewModelSharedStateProvider
    ) {
        self._selectedConversation = sharedStateProvider.selectedConversationPublisher
        self.sharedStateProvider = sharedStateProvider
    }
}
