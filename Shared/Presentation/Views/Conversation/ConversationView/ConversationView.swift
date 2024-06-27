//
//  ContentView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.
//
import SwiftUI


struct ConversationView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: ConversationViewModel
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                contentView
                bottomBar
            }
            .navigationBarTitle("Own GPT", displayMode: .inline)
            .toolbar {
                HeaderView(viewModel: viewModel)
            }
        }
    }
    
    @ViewBuilder
    func loadFirst() -> some View {
        Button("load first conversation") {
            Task {
                await viewModel.loadFirstConversation()
            }
        }
    }
    @ViewBuilder
    func totalConverations() -> some View {
        Button("load first conversation") {
            Task {
                 viewModel.printTotalConversations()
            }
        }
    }
    @ViewBuilder
    private var contentView: some View {
        if viewModel.showPlaceholder {
            PlaceHolderLogo()
        } else {
            messageList
        }
    }
    
    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ConversationList(messages: viewModel.messages)
                    .onChange(of: viewModel.messages.count) { _, _ in
                        scrollToBottom(proxy)
                    }

            }
        }
    }
    
    private var bottomBar: some View {
        BottomBarView(
            isSendButtonDisabled: $viewModel.isSendButtonDisabled,
            inputMessage: $viewModel.inputMessage,
            isTextFieldFocused: $isTextFieldFocused,
            sendTapped: viewModel.sendTapped
        )
    }
    
    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        guard let id = viewModel.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
}



struct HeaderView: ToolbarContent {
    @ObservedObject var viewModel: ConversationViewModel
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            
            Button(action: {
                Task { @MainActor in
                    viewModel.createNewConversation()
                }
            }) {
                Image(systemName: "square.and.pencil")
            }
        }
    }
}




//    #if os(watchOS)
//        Button("Clear", role: .destructive) {
//            chatScreenViewModel.clearMessages()
//            print("Button Tapped")
//        }
//        .buttonBorderShape(.roundedRectangle)
//        .frame(width: 75, height: 50)
//        .fixedSize(horizontal: true, vertical: true)
//        #endif
