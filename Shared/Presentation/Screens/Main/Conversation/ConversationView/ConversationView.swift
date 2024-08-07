//
//  ContentView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/18/23.
//
import SwiftUI

import SwiftUI

struct ConversationView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var vm: ConversationViewModel
    @FocusState private var isTextFieldFocused: Bool
    @State private var isServiceSelectorPresented = false
    var tapped = {}
    
    var body: some View {
        NavigationView {
            VStack {
                contentView
                bottomBar.onAppear {
                    isTextFieldFocused = true
                }
            }
            .navigationTitle("OwnGPT")
            .navigationBarTitleDisplayMode(.inline) // WIP
            
            .toolbar {
                toolbarContent
            }
        }
        .sheet(isPresented: $isServiceSelectorPresented) {
            ServiceSelectorView()
        }
    }
}

//MARK: SubViews
extension ConversationView {
    
    
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
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        // left
        ToolbarItem(placement: .topBarLeading) {
            HamburgerMenuButton(action: tapped)
        }
//         middle
//        ToolbarItem(placement: .principal) {
//            CustomNavBarPicker(selectedOption: $selectedOption, showServiceSelector: $isServiceSelectorPresented)
//        }
        
        // right
        ToolBarView(placement: .topBarTrailing, systemName: "square.and.pencil") {
            vm.createNewConversation()
        }
    }
    
    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        guard let id = vm.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
}
struct HamburgerMenuButton: View {
    @Environment(\.colorScheme) var colorScheme
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                Rectangle()
                    .fill(colorScheme == .dark ? Color.white : Color.black)
                    .frame(width: 18, height: 3.5)
                    .padding(.bottom, 1)
                    .cornerRadius(1)

                Rectangle()
                    .fill(colorScheme == .dark ? Color.white : Color.black)
                    .frame(width: 12, height: 3.5)
                    .cornerRadius(1)
            }
            .background(Color.clear)
        }
    }
}



struct CustomNavBarPicker<T: CaseIterable & Identifiable & Hashable>: View where T: RawRepresentable, T.RawValue == String, T.AllCases: RandomAccessCollection {
    @Binding var selectedOption: T
    @Binding var showServiceSelector: Bool
    let title: String
    
    var body: some View {
        Menu {
            Picker(title, selection: $selectedOption) {
                ForEach(T.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            Button("Service Selector") {
                showServiceSelector = true
            }
        } label: {
            HStack {
                Text(selectedOption.rawValue)
                    .font(.headline)
                Image(systemName: "chevron.down")
                    .font(.footnote)
                    .foregroundColor(.gray)
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
