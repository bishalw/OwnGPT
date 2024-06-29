//
//  ContentView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.
//
import SwiftUI

struct ConversationView: View {
    
    @Environment(\.colorScheme) var colorScheme
    //MARK: Dependency
    @StateObject var vm: ConversationViewModel
    //MARK: UI State
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                contentView
                bottomBar
            }
            .navigationBarTitle("Own GPT", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    
                    Button(action: {
                        vm.createNewConversation()
                    }
                    ) {
                        Image(systemName: "square.and.pencil")
                            .font(.headline)
                            .foregroundColor(colorScheme == .dark ? .darkForeground : .lightForeground)
                    }.disabled(false)
                }

            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if vm.showPlaceholder {
            PlaceHolderLogo()
        } else {
            messageList
        }
    }
    
    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ConversationList(messages: vm.messages)
                    .onChange(of: vm.messages.count) { _, _ in
                        scrollToBottom(proxy)
                    }

            }
        }
    }
    
    private var bottomBar: some View {
        BottomBarView(
            isSendButtonDisabled: $vm.isSendButtonDisabled,
            inputMessage: $vm.inputMessage,
            isTextFieldFocused: $isTextFieldFocused,
            sendTapped: vm.sendTapped
        )
    }
    
    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        guard let id = vm.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
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
