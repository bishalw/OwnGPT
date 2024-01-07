//
//  ButtonView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/27/23.
//

import SwiftUI

struct MessageInput: View {
    
    @Binding var inputMessage: String
    @FocusState.Binding var isTextFieldFocused: Bool
    var isSendButtonDisabled: Bool
    var sendTapped : () -> Void
   
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            #if os(iOS)
            TextField("Send a message...", text: $inputMessage, axis: .vertical)
                .textFieldStyle(OvalTextFieldStyle())
                .focused($isTextFieldFocused)
                .disabled(isSendButtonDisabled)
                
            #endif
            #if os(watchOS)
            TextField("Send", text: $inputMessage, axis: .vertical)
                .buttonBorderShape(.roundedRectangle)
                .frame(width: 75, height: 45)
                .fixedSize(horizontal: true, vertical: true)
                .onSubmit {
                    sendTapped()
                }
            #endif
                
            if isSendButtonDisabled {
                DotLoadingView()
            } else {
                SendButtonView(sendTapped: {
                    sendTapped()
                })
                .disabled(isSendButtonDisabled)
                // TODO: ask bipul to move the disable logic to the parent
            }
        }.padding()
    }
}
struct SendButtonView: View {
    
    let sendTapped: () -> Void
    
    var body: some View {
        Button(action: {
                sendTapped()
        }) {
            Text("Send")
        }
    }
}
