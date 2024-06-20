//
//  ButtonView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/27/23.
//

import SwiftUI

struct BottomBarView: View {
    
    @Binding var inputMessage: String
    @FocusState.Binding var isTextFieldFocused: Bool
    @State private var isExpanded = false
    
    var isSendButtonDisabled: Bool
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
                isSendButtonDisabled: isSendButtonDisabled,
                showExpandedView: $isExpanded
            )
            SendButtonView(sendTapped: sendTapped)

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

    var body: some View {
        
        Button(action: {
                showExpandedView.toggle()
        }) {
        Image(systemName: "plus")
            .font(.system(size: 15))
            .foregroundColor(.white)
            .frame(width: 30, height: 30)
            .background(Circle().foregroundColor(.gray))
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

struct DynamicTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var isMultiline: Bool
    @Binding var height: CGFloat
    var maxWidth: CGFloat
    var maxCharacterCount: Int
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.text = text
        textView.font = .systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = .byWordWrapping // Enable word wrapping
        textView.textContainer.maximumNumberOfLines = isMultiline ? 0 : 1 // Limit to one line if not multiline
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        // ... (rest of your existing code) ...

        if uiView.text.count > maxCharacterCount {
            // Find the last space before exceeding the limit
            if let lastSpaceIndex = uiView.text.prefix(maxCharacterCount).lastIndex(of: " ") {
                let newText = uiView.text.replacingCharacters(
                    in: lastSpaceIndex..<lastSpaceIndex, // Use ..< for an empty range
                    with: "\n" // Insert a newline
                )
                uiView.text = newText
            } else {
                // If no space, insert newline at the limit
                let newText = uiView.text.prefix(maxCharacterCount) + "\n" + uiView.text.dropFirst(maxCharacterCount)
                uiView.text = String(newText)
            }
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: DynamicTextField

        init(_ parent: DynamicTextField) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}
struct MessageInput: View {
    @Binding var inputMessage: String
    @FocusState.Binding var isTextFieldFocused: Bool
    var isSendButtonDisabled: Bool
    @Binding var showExpandedView: Bool
    @State private var height: CGFloat = 40
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            #if os(iOS)
            TextField("Send a message...", text: $inputMessage, axis: .vertical)
                .ovalTextFieldStyle()
                .focused($isTextFieldFocused)
                .onChange(of: isTextFieldFocused) { oldValue, newValue in
                    showExpandedView = !newValue  // Toggle showExpandedView based on focus
                }
//            DynamicTextField(text: $inputMessage, placeholder: "Enter some multiline text", isMultiline: true, height: $height, maxWidth: 30, maxCharacterCount: <#Int#>)
//                           .frame(width: 250, height: 40)
                            
                           
        
            #endif
        }
        .padding()
    }
}

struct SendButtonView: View {
    
    let sendTapped: () -> Void
    
    var body: some View {
        Button(action: {
                sendTapped()

        }) {
            Image(systemName: "arrow.up.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct BottomBarViewPreview: PreviewProvider {
    
    static var previews: some View {
        BottomBarView(
            inputMessage: .constant("Hello"),
            isTextFieldFocused: FocusState().projectedValue,
            isSendButtonDisabled: false,
            sendTapped: {}
        )
    }
}



//#if os(watchOS)
//TextField("Send", text: $inputMessage, axis: .vertical)
//    .buttonBorderShape(.roundedRectangle)
//    .frame(width: 75, height: 45)
//    .fixedSize(horizontal: true, vertical: true)
//    .onSubmit {
//        sendTapped()
//    }
//#endif
