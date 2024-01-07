//
//  ChatsViewModel.swift
//  OwnGpt
//
//  Created by Bishalw on 8/6/23.
//

import Foundation
import SwiftUI
import Combine
@MainActor
final class ConversationsViewModel: ObservableObject {
    @Published var conversations: [Conversation] = []
    private var store: ConversationsStore
    init(store: ConversationsStore) {
        self.store = store
//        store.conversations.publisher.sink {  in
//            <#code#>
//        } receiveValue: { <#Self.Output#> in
//            <#code#>
//        }

    }
}
