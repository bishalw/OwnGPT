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
        ServiceSelectorView(configStore: ConfigurationStoreImpl())
        Form(content: {
            Section ("Conversations"){
                Button(action: {
                    Task {

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
                Button(action: {
                    Task {
                        core.userDefaultStore.clearCache
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
                
            }
        })
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    SettingsView()
}
