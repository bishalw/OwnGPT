//
//  ButtonView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/27/23.

import SwiftUI

struct BottomBarView: View {
    @State private var isExpanded = false
    @Binding var isSendButtonDisabled: Bool
    @Binding var inputMessage: String
    @FocusState.Binding var isTextFieldFocused: Bool
    let sendTapped: () -> Void
    
    var body: some View {
        
        HStack {
            expandableView
            MessageInput(
                inputMessage: $inputMessage,
                isTextFieldFocused: $isTextFieldFocused,
                showExpandedView: $isExpanded, sendTapped: sendTapped
            )
            SendButtonView(sendTapped: sendTapped, isSendButtonDisabled: $isSendButtonDisabled)
        }
        .padding()
        .onChange(of: inputMessage) { _, newValue in
            if !newValue.isEmpty {
                isExpanded = false
            }
        }
        .onChange(of: isTextFieldFocused) { _, newValue in
            if newValue {
                isExpanded = true
            }
        }
    }
    
    @ViewBuilder
    private var expandableView: some View {
        
        if isExpanded {
            ExpandedOptionsView()
                .transition(.scale)
        } else {
            PlusButtonView(showExpandedView: $isExpanded, isTextFieldFocused: $isTextFieldFocused)
                .animation(.spring(), value: isExpanded)
        }
    }
}

struct PlusButtonView: View {
    @Binding var showExpandedView: Bool
    @FocusState.Binding var isTextFieldFocused: Bool
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: { showExpandedView.toggle() }) {
            ZStack {
                Circle()
//                  .foregroundColor(colorScheme == .light ? .white : .black)
                    .foregroundColor(colorScheme == .dark ? .plusButtonDark : .plusButtonLight)
                    .frame(width: 30, height: 30)
                
                Image(systemName: "plus")
                    .font(.system(size: 15, weight: .bold))  // Adjust size here
                    .foregroundColor(colorScheme == .dark ? .gray : Color(.init(gray: 0.3, alpha: 1)))
            }
        }
    }
}

struct ExpandedOptionsView: View {
    @Environment(\.colorScheme) private var colorScheme
    private let options = ["camera", "photo", "video"]
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(options, id: \.self) { systemName in
                Image(systemName: systemName)
                    .font(.system(size: 20))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
        }
        .padding(.top, 5)
    }
}

struct MessageInput: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var inputMessage: String
    @FocusState.Binding var isTextFieldFocused: Bool
    @Binding var showExpandedView: Bool
    var sendTapped: () -> Void

    var body: some View {
        content
    }

    @ViewBuilder
    private var content: some View {
        #if os(iOS)
        ZStack(alignment: .trailing) {
            ZStack(alignment: .leading) {
                if inputMessage.isEmpty {
                    Text("Message")
                        .foregroundColor(Color(.systemGray))
                        .padding(.horizontal, 8)
                }

                TextField("", text: $inputMessage)
                    .padding(8)
                    .padding(.trailing, inputMessage.isEmpty ? 30 : 8)
                    .foregroundColor(colorScheme == .dark ?  .messageInputDark : .messageInputLight)
                    .accentColor(Color(.systemGray))
                    .focused($isTextFieldFocused)
                    .onChange(of: isTextFieldFocused) { _, newValue in
                        showExpandedView = !newValue
                    }
            }

            if inputMessage.isEmpty {
                Button(action: {
                    // Action for the microphone button
                }) {
                    Image(systemName: "mic.fill")
                        .foregroundColor(.gray)
                        .frame(width: 30, height: 30)
                }
                .padding(.trailing, 8)
            }
        }
        .background(colorScheme == .dark ? .black : .white)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.systemGray), lineWidth: 1)
        )
        #elseif os(watchOS)
        TextField("Send", text: $inputMessage, axis: .vertical)
            .buttonBorderShape(.roundedRectangle)
            .frame(width: 75, height: 45)
            .fixedSize(horizontal: true, vertical: true)
            .onSubmit(sendTapped)
        #endif
    }
}

struct SendButtonView: View {
    @Environment(\.colorScheme) private var colorScheme
    let sendTapped: () -> Void
    @Binding var isSendButtonDisabled: Bool
    
    var body: some View {
        Button(action: sendTapped) {
            Image(systemName: "arrow.up.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(colorScheme == .dark ? .white : .black)
              
        }
        .disabled(isSendButtonDisabled)
    }
}




