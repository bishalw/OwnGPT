//
//  ChatRowView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/19/23.
//

import SwiftUI

struct ChatRowView: View {
    @Environment(\.colorScheme) private var colorScheme
    let message: ChatRow
    let retryCallback: (ChatRow) -> Void

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            ChatRowItem(text: message.sendText, image: message.UserIcon, bgColor: colorScheme == .light ? .white : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 0.5))
            if let text = message.responseText {
                Divider()
                VStack {
                    ChatRowItem(text: text, image: message.responseGPTIcon, bgColor: colorScheme == .light ? .gray.opacity(0.1) : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 1))
                    if let error = message.responseError {
                        ErrorView(error: error, retryCallback: { retryCallback(message) })
                    }
                    if message.isInteractingWithOwnGPT {
                        DotLoadingView()
                    }
                }
            }
        }
    }
}

struct ChatRowItem: View {
    let text: String
    let image: String
    let bgColor: Color

    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            iconImage(name: image)
            VStack(alignment: .leading) {
                if !text.isEmpty {
                    Text(text)
                        .multilineTextAlignment(.leading)
                    #if os(iOS)
                        .textSelection(.enabled)
                    #endif
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(bgColor)
    }
    
    @ViewBuilder
    func iconImage(name: String) -> some View {
        if name.hasPrefix("http"), let url = URL(string: name) {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .frame(width: 25, height: 25)
            } placeholder: {
                ProgressView()
            }
        } else {
            Image(systemName: name)
                .resizable()
                .frame(width: 25, height: 25)
        }
    }
}

struct ErrorView: View {
    let error: String
    let retryCallback: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text("Error: \(error)")
                .foregroundColor(.red)
                .multilineTextAlignment(.leading)
            
            Button("Retry") {
                retryCallback()
            }
        }
    }
}

struct ChatRowView_Previews: PreviewProvider {
    
    static let message = ChatRow (isInteractingWithOwnGPT: true, UserIcon: "person.crop.circle", sendText: "What is swiftui", responseGPTIcon: "brain", responseText: "swiftui allows user to blah blah blah after they blooh blah hoelk and they ios macos dom doom applications")
    
    static let message2 = ChatRow (isInteractingWithOwnGPT: false, UserIcon: "person.crop.circle", sendText: "What is swiftui", responseGPTIcon: "brain", responseText: "", responseError: "ChatGPT is currently not available")
    
    static var previews: some View {
        NavigationStack {
            ScrollView {
                ChatRowView(message: message, retryCallback: { messageRow in
                    
                })
                ChatRowView(message: message2, retryCallback: { messageRow in
                    
                })
                    
                .frame(width: 400)
                .previewLayout(.sizeThatFits)
                    
                }
            }
        }
    }



  
