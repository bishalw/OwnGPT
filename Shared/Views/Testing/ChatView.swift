//
//  ChatView.swift
//  OwnGpt
//
//  Created by Bishalw on 12/8/23.
//

import Foundation
import SwiftUI
struct MessageView: View {
    let message: Message

    var body: some View {
        switch message.content {
        case .message(let string):
            Text(string.trimmed)
        case .error(let error):
            Text(error.localizedDescription)
        }
    }
}

struct ChatView: View {
   
    
    @StateObject var vm: ChatViewModel
    

    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(vm.store.conversation.messages) { message in
                            MessageView(message: message)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
            }
            .padding()

            HStack {
                TextField("Type a message", text: $vm.inputMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Send") {
                    Task {
                        await vm.sendMessage()
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding()
        }
        .navigationTitle("Chat")
    }
}
