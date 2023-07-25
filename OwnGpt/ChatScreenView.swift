//
//  ContentView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.
//

import SwiftUI

struct ChatScreenView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var chatScreenViewModel: ChatScreenViewModel
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        chatListView.navigationTitle("Own GPT")
    }
    var chatListView: some View {
        
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(chatScreenViewModel.messages) { message in
                            ChatRowView(message: message) { message in
                                Task { @MainActor in
                                    await chatScreenViewModel.retry(message: message)
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
           
            .onChange(of: chatScreenViewModel.messages.last?.responseText, { _, _ in
              scrollToBottom(proxy: proxy)
            })
            
        }
        
    }
    
    func bottomView(proxy: ScrollViewProxy) -> some View {
        
            HStack(alignment: .center, spacing: 8, content: {
                TextField("Send a message...", text: $chatScreenViewModel.inputMessage, axis: .vertical)
                    .textFieldStyle(OvalTextFieldStyle())
                    .focused($isTextFieldFocused)
                    .disabled(chatScreenViewModel.isInteractingWithOwnGPT)
                
                if chatScreenViewModel.isInteractingWithOwnGPT {
                    DotLoadingView()
                } else {
                    Button(action: {
                        Task { @MainActor in
                            isTextFieldFocused = false
                            scrollToBottom(proxy: proxy)
                            await chatScreenViewModel.sendTapped()
                        }
                    }, label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 30))
                         
                    }).disabled(chatScreenViewModel.inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            })
            .padding(.horizontal, 16)
            .padding(.top, 12)
    }
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = chatScreenViewModel.messages.last?.id  else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
}

#Preview {
        ChatScreenView()
}

