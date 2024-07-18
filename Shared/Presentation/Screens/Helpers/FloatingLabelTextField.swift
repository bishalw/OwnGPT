//
//  FloatingLabelTextField.swift
//  OwnGpt
//
//  Created by Bishalw on 7/17/24.
//

import SwiftUI

struct FloatingLabelTextField<Content: View>: View {
    let title: String
    @Binding var text: String
    @ViewBuilder let content: () -> Content
    @State private var isEditing = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(title)
                .foregroundColor(text.isEmpty ? Color(.placeholderText) : .accentColor)
                .offset(y: text.isEmpty && !isEditing ? -8 : -35)
                .scaleEffect(text.isEmpty && !isEditing ? 1 : 0.75, anchor: .leading)
            
            content()
                .textFieldStyle(PlainTextFieldStyle())
                .offset(y: -8)
        }
        .padding(.top)
        .animation(.easeInOut(duration: 0.2), value: text)
    }
}
struct SecureFloatingLabelTextField: View {
    let title: String
    @Binding var text: String
    @State private var isSecure = true
    
    var body: some View {
        FloatingLabelTextField(title: title, text: $text) {
            HStack {
                if isSecure {
                    SecureField("", text: $text)
                } else {
                    TextField("", text: $text)
                }
                
                Button(action: {
                    isSecure.toggle()
                }) {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
struct FloatingLabelTextField_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var text1 = ""
        @State private var text2 = "Filled Text"
        
        var body: some View {
            VStack(spacing: 20) {
                FloatingLabelTextField(title: "Empty", text: $text1) {
                    TextField("", text: $text1)
                }
                FloatingLabelTextField(title: "Filled", text: $text2) {
                    TextField("", text: $text2)
                }
            }
            .padding()
            .previewLayout(.sizeThatFits)
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}

