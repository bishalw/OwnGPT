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
        NavigationView {
            VStack {
                if conversationViewModel.showPlaceholder {
                    PlaceHolderLogo()
                } else {
                    ScrollViewReader { proxy in
                        ScrollView {
                            ConversationList(messages: conversationViewModel.messages)
                                .onChange(of: conversationViewModel.messages.count) { _, _ in
                                    scrollToBottom(proxy)
                                }
                        }
                    }
                }
                BottomBarView(
                    isSendButtonDisabled: $conversationViewModel.isSendButtonDisabled,
                    inputMessage: $conversationViewModel.inputMessage,
                    isTextFieldFocused: $isTextFieldFocused)
                {
                    conversationViewModel.sendTapped()
                }
            }
            .navigationBarTitle("Own GPT", displayMode: .inline)
            .toolbar {
                HeaderView(viewModel: conversationViewModel)
            }
        }
    }

    private var backgroundColorForMode: Color {
        colorScheme == .dark ? Color(white: 0.15) : Color(white: 0.95)
    }
    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        guard let id = conversationViewModel.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
    
    @ViewBuilder
    func placeHolderLogo() -> some View {
            VStack {
                Spacer()
                Image(systemName: "circle.hexagonpath")
                    .font(.system(size: 50))
                    .foregroundColor(colorScheme == .light ? .black : .white )
                    .offset(y: 0)
                Text("Start a new conversation")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.top)
                Spacer()
            }
        }
    
}


struct HeaderView: ToolbarContent {
    @ObservedObject var viewModel: ConversationViewModel
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                viewModel.createNewConversation()
            }) {
                Image(systemName: "square.and.pencil")
            }
        }
    }
}

//                Button("load first conversation") {
//                    conversationViewModel.loadFirstConversation()
//                }
//                Button("Print Conversation Count") {
//                    conversationViewModel.printTotalConversations()
//                }


//    #if os(watchOS)
//        Button("Clear", role: .destructive) {
//            chatScreenViewModel.clearMessages()
//            print("Button Tapped")
//        }
//        .buttonBorderShape(.roundedRectangle)
//        .frame(width: 75, height: 50)
//        .fixedSize(horizontal: true, vertical: true)
//        #endif
