//
//  MainView.swift
//  OwnGpt
//
//  Created by Bishalw on 6/25/24.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.colorScheme) var colorScheme
    // MARK: - Dependency
    @StateObject var mainViewSharedStateManager = MainViewSharedStateManager()
    @EnvironmentObject var core: Core
    // MARK: - Gesture Handling
    @State private var offset: CGFloat = 0
    @State private var lastStoredOffset: CGFloat = 0
    @GestureState private var gestureOffset: CGFloat = 0
    // MARK: - UI State
    @State private var showMenu: Bool = false
    @State private var isSearching: Bool = false
    
    
    
    private let sidebarWidth: CGFloat = UIScreen.main.bounds.width - 90
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                sidebarView(geometry: geometry)
                conversationView(geometry: geometry)
            }
            .gesture(mainDragGesture)
            .simultaneousGesture(secondaryDragGesture(geometry: geometry))
        }
    }
}

// MARK: - Subviews
extension MainView {
    
    private func conversationView(geometry: GeometryProxy) -> some View {
        ConversationView(vm: ConversationViewModel(store: ConversationStore(chatGPTAPI: core.chatgptApiService, repo: core.conversationRepository, conversation: mainViewSharedStateManager.selectedConversation), createNewConversation: { 
            let conversation = Conversation()
            mainViewSharedStateManager.selectedConversation = conversation
        }), tapped: {
            withAnimation {
                openSidebar()
            }
        })
            .frame(width: geometry.size.width, height: geometry.size.height)
            .overlay(overlayColor.opacity(overlayOpacity))
            .offset(x: isSearching ? geometry.size.width : offset)
            .id(mainViewSharedStateManager.selectedConversation?.id)
        
    }
    
    
    private func sidebarView(geometry: GeometryProxy) -> some View {
        
        SidebarView(vm: SideBarViewModelImpl(sharedStateProvider: mainViewSharedStateManager, userdefaultStore: core.userDefaultStore), isSearching: $isSearching)
            .frame(width: isSearching ? geometry.size.width : sidebarWidth)
            .offset(x: isSearching ? 0 : -sidebarWidth + offset)
            .animation(.linear, value: isSearching)
    }
}


// MARK: - Gesture Handlers
extension MainView {
    private var mainDragGesture: some Gesture {
        DragGesture()
            .updating($gestureOffset) { value, state, _ in
                if !isSearching {
                    state = value.translation.width
                }
            }
            .onChanged { _ in
                if !isSearching {
                    updateOffsetOnDrag()
                }
            }
            .onEnded { value in
                if !isSearching {
                    endDragGesture(value: value)
                }
            }
    }
    
    private func secondaryDragGesture(geometry: GeometryProxy) -> some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                if !isSearching && value.translation.width > 0 && offset == 0 {
                    offset = value.translation.width
                }
            }
            .onEnded { value in
                if !isSearching {
                    withAnimation {
                        if value.translation.width > geometry.size.width / 3 {
                            openSidebar()
                        } else {
                            closeSidebar()
                        }
                    }
                }
            }
    }
    
    private func updateOffsetOnDrag() {
        let newOffset = gestureOffset + lastStoredOffset
        if newOffset <= sidebarWidth && newOffset >= 0 {
            offset = newOffset
        }
    }
    
    private func endDragGesture(value: DragGesture.Value) {
        let translationX = value.translation.width
        
        withAnimation(.easeOut(duration: 0.3)) {
            if translationX > 0 {
                if translationX > (sidebarWidth / 4) {
                    openSidebar()
                } else {
                    closeSidebar()
                }
            } else {
                if -translationX > (sidebarWidth / 4) {
                    closeSidebar()
                } else {
                    openSidebar()
                }
            }
        }
        
        lastStoredOffset = offset
    }
}

// MARK: - Helper Methods
extension MainView {
    private func openSidebar() {
        offset = sidebarWidth
        showMenu = true
    }
    
    private func closeSidebar() {
        offset = 0
        showMenu = false
    }
    
    private var overlayColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    private var overlayOpacity: Double {
        let progress = offset / sidebarWidth
        return min(max(progress * 0.15, 0), 0.15)
    }
}

#Preview {
//    MainView()
    EmptyView()
}
