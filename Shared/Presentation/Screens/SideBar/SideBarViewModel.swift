//
//  SideBarViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 6/24/24.
//

import Foundation
import Combine
protocol SiderBarViewModelSharedStateProvider {
    var selectedConversationPublisher: Published<Conversation?> { get }
}


class SideBarViewModel: ObservableObject {
    let mainViewSharedStateManager: MainViewSharedStateManager
    
    @Published var selectedConversation: Conversation?
    
    init(mainViewSharedStateManager: MainViewSharedStateManager) {
        self._selectedConversation = mainViewSharedStateManager.selectedConversationPublisher
        self.mainViewSharedStateManager = mainViewSharedStateManager
    }
    
    
}
