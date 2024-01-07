//
//  ChatRowView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/19/23.
//

import SwiftUI
import Combine


struct MessageRow: View {
    @Environment(\.colorScheme) private var colorScheme
    let message: Message

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            switch message.type {
            case .user:
                MessageRowItem(text: message.content.text, image: message.defaultIconName, bgColor: colorScheme == .light ? .white : .notLight)
            case .system:
                if case let .error(error) = message.content {
                    ErrorView(error: error.localizedDescription)
                } else {
                    MessageRowItem(text: message.content.text, image: message.defaultIconName, bgColor: colorScheme == .light ? .gray.opacity(0.1) : .notLight)
                }            }
            if case.system = message.type, message.isStreaming {
                DotLoadingView()
            }
        }
    }
    @ViewBuilder
    func MessageRowItem(text: String, image: String, bgColor: Color) -> some View {
        HStack(alignment: .top, spacing: 24) {
            IconImage(name: image)
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
    func IconImage(name: String) -> some View {
            Image(systemName: name)
                .resizable()
                .frame(width: 25, height: 25)
    }
    @ViewBuilder
    func ErrorView(error: Error) -> some View {
        VStack(alignment: .leading) {
            Text("Error: \(String(describing: error))")
                .foregroundColor(.red)
                .multilineTextAlignment(.leading)
        }
    }
}


//struct ChatRowView_Previews: PreviewProvider {

//    static var previews: some View {
            
//    }
