//
//  ButtonView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/27/23.
//

import SwiftUI

struct BottomBarView: View {
    
    @State private var isExpanded = false
    @Binding var isSendButtonDisabled: Bool
    @Binding var inputMessage: String
    @FocusState.Binding var isTextFieldFocused: Bool
    
    var sendTapped: () -> Void
    
    var body: some View {
        HStack {
            if !isExpanded {
                PlusButtonView(showExpandedView: $isExpanded, isTextFieldFocused: $isTextFieldFocused)
                    .animation(.spring(), value: isExpanded)
            }
            if isExpanded {
                ExpandedOptionsView()
                    .transition(.scale)
            }
            
            MessageInput(
                inputMessage: $inputMessage,
                isTextFieldFocused: $isTextFieldFocused,
                showExpandedView: $isExpanded
            )
            SendButtonView(sendTapped: sendTapped, isSendButtonDisabled: $isSendButtonDisabled)

        }
        .padding()
    
        .onChange(of: inputMessage, initial: true) { _, newValue in
            if !newValue.isEmpty { // Hide ExpandedOptionsView if typing // fix later
                isExpanded = false
            }
        }
        .onChange(of: isTextFieldFocused) { _, newValue in // Update onChange for isTextFieldFocused // fix later
            if newValue && !isExpanded {
                isExpanded.toggle()
            }
        }
    }
}

struct PlusButtonView: View {
    
    @Binding var showExpandedView: Bool
    @FocusState.Binding var isTextFieldFocused: Bool
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        
        Button(action: {
                showExpandedView.toggle()
        }) {
        Image(systemName: "plus")
            .font(.system(size: 20))
            .foregroundColor(colorScheme == .light ? .white : .black )
            .frame(width: 30, height: 30)
            .background(Circle().foregroundColor(.blue))
        }
        
    }
}
struct ExpandedOptionsView: View {
    
    var options: [String] = ["camera", "photo", "video" ]
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(options, id: \.self) { systemName in
                Image(systemName: systemName)
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
            }
        }
        .padding(.top, 5)
    }
}

struct MessageInput: View {
    @Binding var inputMessage: String
    @FocusState.Binding var isTextFieldFocused: Bool
    @Binding var showExpandedView: Bool
    @State private var height: CGFloat = 40
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            #if os(iOS)
            TextField("Send a message...", text: $inputMessage, axis: .vertical)
                .ovalTextFieldStyle()
                .focused($isTextFieldFocused)
                .onChange(of: isTextFieldFocused) { oldValue, newValue in
                    showExpandedView = !newValue
                }
                            
            #endif
        }
        .padding()
    }
}

struct SendButtonView: View {
    
    let sendTapped: () -> Void
    @Binding var isSendButtonDisabled: Bool
    var body: some View {
        Button(action: {
                sendTapped()
                
        }) {
            Image(systemName: "arrow.up.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .aspectRatio(contentMode: .fit)
        }
        .disabled(isSendButtonDisabled)
    }
}

//struct BottomBarViewPreview: PreviewProvider {
//    
//    static var previews: some View {
//        BottomBarView(
//            inputMessage: .constant("Hello"),
//            isTextFieldFocused: FocusState().projectedValue,
//            isSendButtonDisabled: false,
//            sendTapped: {}
//        )
//    }
//}



//#if os(watchOS)
//TextField("Send", text: $inputMessage, axis: .vertical)
//    .buttonBorderShape(.roundedRectangle)
//    .frame(width: 75, height: 45)
//    .fixedSize(horizontal: true, vertical: true)
//    .onSubmit {
//        sendTapped()
//    }
//#endif
