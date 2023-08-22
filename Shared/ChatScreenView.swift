//
//  ContentView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.
//

import SwiftUI


struct ChatScreenView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var chatScreenViewModel: ChatScreenViewModel
    @FocusState private var isTextFieldFocused: Bool
    var body: some View {
        ScrollViewReader { proxy in
            NavigationView {
                VStack {
                        ScrollView {
                            
                            ChatListView(messages: chatScreenViewModel.messages, retryCallback: { chat in
                                Task { @MainActor in
                                    await chatScreenViewModel.retry(message: chat)
                                }
                            })
                            .onChange(of: chatScreenViewModel.messages.count) { _, _ in
                                guard let lastMessage = chatScreenViewModel.messages.last,
                                      case .message(string: _) = lastMessage.content else { return }
                                scrollToBottom(proxy)
                            }

                               
                                .onChange(of: isTextFieldFocused) {
                                    chatScreenViewModel.isTextFieldFocused = isTextFieldFocused
                                }
                            
                            Spacer()
                            Divider()
                            
                           
                            BottomView(inputMessage: $chatScreenViewModel.inputMessage,
                                       isTextFieldFocused: $isTextFieldFocused,
                                       isButtonViewDisabled: chatScreenViewModel.isStreaming,
                                       isSendButtonDisabled: chatScreenViewModel.isSendButtonDisabled) {
                                Task { @MainActor in
                                    await chatScreenViewModel.sendTapped()
                                }
                              
                            }
                            
                        }
                        .navigationBarTitle("Own GPT")
                }
            }
            
        }
    }
    
    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        guard let id = chatScreenViewModel.messages.last?.id else { return }
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
