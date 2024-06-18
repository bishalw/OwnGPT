//
//  ContentView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.
//

import SwiftUI


struct ConversationView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var conversationViewModel: ConversationViewModel
    @FocusState private var isTextFieldFocused: Bool
    var body: some View {
        ScrollViewReader { proxy in
            NavigationView {
                VStack {
                    ScrollView {
                        ConversationList(messages: conversationViewModel.messages)
                            .onChange(of: conversationViewModel.messages.count) { _, _ in
                                scrollToBottom(proxy)
                            }
                            .onChange(of: isTextFieldFocused) {
                                conversationViewModel.isTextFieldFocused = isTextFieldFocused
                            }
                    }
                    BottomBarView(inputMessage: $conversationViewModel.inputMessage, isTextFieldFocused: $isTextFieldFocused, isSendButtonDisabled: conversationViewModel.isSendButtonDisabled) {
                        Task {
                            conversationViewModel.sendTapped
                        }
                    }
                    .navigationBarTitle("Own GPT", displayMode: .inline)
                    .toolbar(content: {
                        HeaderView()
                    })
                }
            }
            
        }
    }
    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        guard let id = conversationViewModel.messages.last?.id else { return }
              proxy.scrollTo(id, anchor: .bottomTrailing)
    }
}

#Preview {
    ConversationView (conversationViewModel: ConversationViewModel(store: ConversationStore(chatGPTAPI: ChatGPTAPIServiceImpl(networkService: NetworkServiceImpl(), apiKey: "h"), repo: ConversationRepositoryImpl(conversationPersistenceService: ConversationPersistenceService(manager: PersistenceController(inMemory: true))))))
    
}

//#Preview {
//    ChatScreenView(chatScreenViewModel: ChatScreenViewModel(api: .init(apiKey: Constants.apiKey), retryCallback: { ChatRow in
//        
//    }
//    ))
//}

//    #if os(watchOS)
//        Button("Clear", role: .destructive) {
//            chatScreenViewModel.clearMessages()
//            print("Button Tapped")
//        }
//        .buttonBorderShape(.roundedRectangle)
//        .frame(width: 75, height: 50)
//        .fixedSize(horizontal: true, vertical: true)
//        #endif
