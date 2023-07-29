//
//  ButtonView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/27/23.
//

import SwiftUI

struct BottomView: View {
    
    @Binding var inputMessage: String
    @FocusState.Binding var isTextFieldFocused: Bool
    var isInteractingWithOwnGpt: Bool
    var isSendButtonDisabled: Bool
    var sendTapped : () -> Void
   
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            #if os(iOS)
            TextField("Send a message...", text: $inputMessage, axis: .vertical)
                .textFieldStyle(OvalTextFieldStyle())
                .focused($isTextFieldFocused)
                .disabled(isInteractingWithOwnGpt)
                
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
                
            if isInteractingWithOwnGpt {
                DotLoadingView()
            } else {
                SendButtonView(sendTapped: {
                    sendTapped()
                })
                .disabled(isSendButtonDisabled)

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
