//
//  ContentView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.
//

import SwiftUI

struct ChatScreenView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var chatViewModel: ChatViewModel
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        
        chatListView.navigationTitle("Own GPT")
    }

    var chatListView: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(chatViewModel.messages) { message in
                            ChatRowView(message: message) { message in
                                Task { @MainActor in
                                    await chatViewModel.retry(message: message)
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        isTextFieldFocused = false
                    }
                }
                Divider()
                bottomView(proxy: proxy)
                Spacer()
            }
            .onChange(of: chatViewModel.messages.last?.responseText) { _ in
                 scrollToBottom(proxy: proxy)
            }
        }
        .background {
        }
    }
    
    func bottomView(proxy: ScrollViewProxy) -> some View {
        
            HStack(alignment: .center, spacing: 8, content: {
                TextField("Send a message...", text: $chatViewModel.inputMessage, axis: .vertical)
                    
                    .textFieldStyle(OvalTextFieldStyle())
                    .focused($isTextFieldFocused)
                    .disabled(chatViewModel.isInteractingWithOwnGPT)
                
                if chatViewModel.isInteractingWithOwnGPT {
                    DotLoadingView()
                } else {
                    Button(action: {
                        Task { @MainActor in
                            isTextFieldFocused = false
                            scrollToBottom(proxy: proxy)
                            await chatViewModel.sendTapped()
                        }
                    }, label: {
                        Image(systemName: "paperplane.circle.fill")
                            .rotationEffect(.degrees(45))
                            .font(.system(size: 30))
                         
                    }).disabled(chatViewModel.inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            })
            .padding(.horizontal, 16)
            .padding(.top, 12)
        
    }
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = chatViewModel.messages.last?.id  else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
}

#Preview {
    NavigationStack{
        ChatScreenView()
    }
}
