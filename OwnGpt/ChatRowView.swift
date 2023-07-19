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
            chatRow(text: message.sendText, image: message.UserIcon, bgColor: colorScheme == .light ? .white : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 0.5))
            
            if let text = message.responseText {
                Divider()
                chatRow(text: text, image: message.responseGPTIcon, bgColor: colorScheme == .light ? .gray.opacity(0.1) : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 1), responseError: message.responseError, showDotLoading: message.isInteractingWithOwnGPT)
            }
        }
    }
    func chatRow(text: String, image: String, bgColor: Color, responseError: String? = nil, showDotLoading: Bool = false) -> some View {
        HStack(alignment: .top, spacing: 24, content: {
            if image.hasPrefix("http"), let url = URL(string: image) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(width: 25, height: 25)
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: image)
                    .resizable()
                    .frame(width: 25, height: 25)
            }
            VStack(alignment: .leading, content: {
                if !text.isEmpty {
                    Text(text)
                        .multilineTextAlignment(.leading)
                        .textSelection(.enabled)
                }
                
                if let error = responseError {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.leading)
                    
                    
                    Button("Retry") {
                        retryCallback(message)
                    }
                    
                }
                if showDotLoading {
                    DotLoadingView().frame(width: 10, height: 10)
                        
                }
            })
           
            
        })
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .backgroundStyle(bgColor)
        
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



  
