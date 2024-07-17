//
//  SettingsView2.swift
//  OwnGpt
//
//  Created by Bishalw on 7/17/24.
//

import SwiftUI

struct FloatingLabelTextField: View {
    let title: String
    @Binding var text: String
    @State private var isEditing = false
    @State private var isSecure = true
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(title)
                .foregroundColor(text.isEmpty ? Color(.placeholderText) : .accentColor)
                .offset(y: text.isEmpty && !isEditing ? -8 : -35)
                .scaleEffect(text.isEmpty && !isEditing ? 1 : 0.75, anchor: .leading)
            HStack {
                if isSecure {
                    SecureField("", text: $text)
                        .textFieldStyle(PlainTextFieldStyle())
                } else {
                    TextField("", text: $text)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                
                Button(action: {
                    isSecure.toggle()
                }) {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .foregroundColor(.secondary)
                }
            }
            .offset(y: -8)
        }
        .padding(.top)
        .animation(.easeInOut(duration: 0.2), value: text)
    }
}

struct SettingsView2: View {
    @State private var apiKey: String = ""
    
    
    var body: some View {
        FloatingLabelTextField(title: "ApiKey", text: $apiKey)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
            .padding()
        
        
        
    }
}
#Preview {
    SettingsView2()
}
