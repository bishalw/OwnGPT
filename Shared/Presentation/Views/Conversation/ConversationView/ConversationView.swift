//
//  ContentView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.
//
//ConversationView(conversationViewModel: ConversationViewModel(store: ConversationStore(chatGPTAPI: ChatGPTAPIServiceImpl(networkService: NetworkServiceImpl(), apiKey: Constants.apiKey), repo: ConversationRepositoryImpl(conversationPersistenceService: ConversationPersistenceService(manager: PersistenceController())))))
import SwiftUI


struct MainView: View {
    @State private var offset: CGFloat = 0
    @State private var lastStoredOffset: CGFloat = 0
    @State private var showMenu: Bool = false
    @GestureState private var gestureOffset: CGFloat = 0
    @State private var isSearching: Bool = false
    @EnvironmentObject var core : Core


    private var sidebarWidth: CGFloat {
        UIScreen.main.bounds.width - 90
    }
  
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                ConversationView(conversationViewModel: ConversationViewModel(store: core.conversationStore, conversation: Conversation(id: UUID(), messages: []))
                )
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(x: offset)
                
                SidebarView()
                    .frame(width: sidebarWidth)
                    .offset(x: -sidebarWidth + offset)
                
                HamburgerButton(showMenu: $showMenu, offset: $offset, sidebarWidth: sidebarWidth)
                    .padding(.leading, 20)
                    .padding(.top, 15)
                    .offset(x: offset)
            }
        }
        .gesture(
            DragGesture()
                .updating($gestureOffset) { value, state, _ in
                    state = value.translation.width
                }
                .onChanged { _ in
                    onChange()
                }
                .onEnded { value in
                    onEnd(value: value)
                }
        )
    }
    
    private func onChange() {
        
        // Get the current translation from the gesture
        let translationX = gestureOffset
        
        // Calculate the new offset by adding the translation to the last stored offset
        let newOffset = translationX + lastStoredOffset
        
        /* Makke sure  the new offset is within bounds:
         - Not less than 0 (sidebar can't move past its starting position)
         - Not greater than sidebarWidth (sidebar can't open more than its width)*/
        if newOffset <= sidebarWidth && newOffset >= 0 {
            offset = newOffset
        }
        
        // Note: We don't update lastStoredOffset here because the gesture hasn't ended yet
    }

    private func onEnd(value: DragGesture.Value) {
        
        // Get the final translation of the gesture
        let translationX = value.translation.width
        
        // Animate the final position of the sidebar
        withAnimation(.easeOut(duration: 0.3)) {
            if translationX > 0 {
                // User dragged from left to right
                if translationX > (sidebarWidth / 2) {
                // If dragged more than halfway, fully open the sidebar
                    offset = sidebarWidth
                    showMenu = true
                } else {
                    // If dragged less than halfway, close the sidebar
                    offset = 0
                    showMenu = false
                }
            } else {
                // User dragged from right to left
                if -translationX > (sidebarWidth / 2) {
                    // If dragged more than halfway, close the sidebar
                    offset = 0
                    showMenu = false
                } else {
                    // If dragged less than halfway, keep the sidebar open
                    offset = sidebarWidth
                    showMenu = true
                }
            }
        }
        
        // Update lastStoredOffset for the next gesture
        lastStoredOffset = offset
    }
}


struct ConversationView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var conversationViewModel: ConversationViewModel
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        ConversationList(messages: conversationViewModel.messages)
                            .onChange(of: conversationViewModel.messages.count) { _, _ in
                                scrollToBottom(proxy)
                            }
                    }
                }
                Button("load first conversation") {
                    conversationViewModel.loadFirstConversation()
                            }
                Button("Print Conversation Count") {
                    conversationViewModel.printTotalConversations()
                            }
                BottomBarView(
                    inputMessage: $conversationViewModel.inputMessage,
                    isTextFieldFocused: $isTextFieldFocused,
                    isSendButtonDisabled: conversationViewModel.isSendButtonDisabled
                ) {
                    conversationViewModel.sendTapped()
                }
            }
            .navigationBarTitle("Own GPT", displayMode: .inline)
            .toolbar {
                HeaderView(viewModel: conversationViewModel)
            }
        }
    }
    
    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        guard let id = conversationViewModel.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
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

//#Preview {
//    ConversationView (conversationViewModel: ConversationViewModel(store: ConversationStore(chatGPTAPI: ChatGPTAPIServiceImpl(networkService: NetworkServiceImpl(), apiKey: "h"), repo: ConversationRepositoryImpl(conversationPersistenceService: ConversationPersistenceService(manager: PersistenceController(inMemory: true))))))
//    
//}

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
