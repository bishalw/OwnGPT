//
//  SettingsView.swift
//  OwnGpt
//
//  Created by Bishalw on 7/22/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var core: Core
    var body: some View {
        ServiceSelectorView()
        Form(content: {
            Section ("Conversations"){
                Button(action: {
                    print("delete pressed")
                    Task {
                        try await core.conversationPersistenceService.deleteAll()
                    }
                }) {
                    Text("Delete All")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                }
                //MARK: If needed for cache delete
                #if DEBUG
                Button(action: {
                    Task {
                        // TODO: remove this later
//                        core.userDefaultStore.clearCache
                    }
                }) {
                    Text("Delete AppStorageCache")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                }
                #endif
                
            }
        })
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    SettingsView()
}
