//
//  WatchOSView.swift
//  OwnGptWatchApp Watch App
//
//  Created by Bishalw on 7/25/23.
//

import SwiftUI

struct WatchOSView: View {

        @Environment(\.colorScheme) var colorScheme
        @StateObject var chatScreenViewModel: ChatScreenViewModel
        @FocusState var isTextFieldFocused: Bool

    var body: some View {
        ScrollViewReader { proxy in
            
                VStack {
                    ScrollView {
//                        ChatListView(chatScreenViewModel: chatScreenViewModel, isTextFieldFocused: $isTextFieldFocused)
                        Color.clear.frame(height: 2)
                            .id("bottom")
                            .onChange(of: chatScreenViewModel.messages.last?.responseText, { _, _ in
                                scrollToBottom(proxy)
                            })
                        Spacer()
                        Divider()
//                        BottomView(inputMessage: $chatScreenViewModel.inputMessage, isTextFieldFocused: _isTextFieldFocused, chatScreenViewModel: chatScreenViewModel, proxy: proxy).focused($isTextFieldFocused)
                    }
                    .edgesIgnoringSafeArea([.horizontal, .bottom])
                    .navigationBarTitle("Own GPT")
            }
            
        }
    }
    private func scrollToBottom(_ proxy: ScrollViewProxy) {
           proxy.scrollTo("bottom", anchor: .bottomTrailing)
       }
    
}

    
    

//struct WatchOSButtonView: View {
//    @Binding var isTextFieldFocused: Bool
//    @ObservedObject var chatScreenViewModel: ChatScreenViewModel
//    let proxy: ScrollViewProxy
//
//    var body: some View {
//        Button("Send") {
//            isTextFieldFocused = false
//            self.presentInputController(withSuggestions: []) { result in
//                Task { @MainActor in
//                    guard !result.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
//                    await chatScreenViewModel.sendTapped()
//                }
//            }
//            print("button tapped")
//        }
//    }
//    
//    private func scrollToBottom() {
//        proxy.scrollTo("bottom", anchor: .bottomTrailing)
//    }
//}


extension WatchOSView {
    typealias StringCompletion = (String) -> Void

    func presentInputController(withSuggestions suggestions: [String], completion: @escaping StringCompletion) {
        WKExtension.shared()
            .visibleInterfaceController?
            .presentTextInputController(withSuggestions: suggestions, allowedInputMode: .plain, completion: { result in
                guard let  result = result as? [String], let firstElement = result.first else {
                    return
                }
                completion(firstElement)
            })
    }
}

//#Preview {
//    WatchOSView()
//}

