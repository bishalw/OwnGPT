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
                                // Scroll to bottom when messages changes
                                scrollToBottom(proxy)
                            }
                            .onChange(of: isTextFieldFocused) {
                                conversationViewModel.isTextFieldFocused = isTextFieldFocused
                            }
                        Spacer()
                        Divider()
                        MessageInput(inputMessage: $conversationViewModel.inputMessage,
                                     isTextFieldFocused: $isTextFieldFocused,
                                     isButtonViewDisabled: conversationViewModel.isStreaming,
                                     isSendButtonDisabled: conversationViewModel.isSendButtonDisabled) {
                            Task { @MainActor in
                                //  await chatScreenViewModel.sendTapped()
                            }
                        }
                    }
                    .navigationBarTitle("Own GPT")
                }
            }
            
        }
    }
    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        guard let id = conversationViewModel.messages.last?.id else { return }
              proxy.scrollTo(id, anchor: .bottomTrailing)
    }
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
