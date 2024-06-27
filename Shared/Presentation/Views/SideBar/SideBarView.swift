//
//  SideBarView.swift
//  OwnGpt
//
//  Created by Bishalw on 6/20/24.
//

import SwiftUI

struct SidebarView: View {
    @State private var searchText: String = ""
    @Binding var isSearching: Bool
    @FocusState private var isSearchFieldFocused: Bool
    @EnvironmentObject var core: Core
    @State var apiKey = Constants.apiKey
    @State private var showModal: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    SearchableView(searchText: $searchText, isSearching: $isSearching, placeholder: "Search", isSearchFieldFocused: $isSearchFieldFocused)
                }
                .padding(.top, -10)
                
                ConversationsView(conversationsViewModel: ConversationsViewModel(conversationsStore: core.conversationsStore))
                    

                Spacer()
                
                HStack {
                    SiderBarBottomView()
                        .onTapGesture {
                            showModal.toggle()
                        }
                        .sheet(isPresented: $showModal) {
                            SettingsView(apiKey: $apiKey)
                        }
                }.padding(.bottom,16)
            }

            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(width: isSearching ? geometry.size.width : nil)
        }
        .onChange(of: isSearchFieldFocused) { _, newValue in
            withAnimation(.easeInOut) {
                isSearching = newValue
            }
        }
    }
    
}
struct SearchableView: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    let placeholder: String
    @FocusState.Binding var isSearchFieldFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 8)
                .accessibility(hidden: true)
            
            TextField(placeholder, text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .accessibilityLabel("Search")
                .accessibilityHint("Enter text to search menu items")
                .focused($isSearchFieldFocused)
           
        }
        .padding([.top, .bottom], 8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isSearchField)
        if isSearchFieldFocused {
            Button("Cancel") {
                isSearchFieldFocused = false
                searchText = ""
            }
        }
    }
}

struct SiderBarBottomView: View {
    
    
    var body: some View {
        Button(action: {
            
        }, label: {
            Image(systemName: "person")
        })
        .font(.title)
        Text("Bishal")
        Spacer()
        Button(action: {
            
        }, label: {
            Image(systemName: "gear")
        })
        .font(.title)
    }
}

struct SettingsView: View {
    @EnvironmentObject var core: Core
    @Binding var apiKey: String
    
    var body: some View {
        VStack(spacing: 20) {
            ApiKey(apiKey: $apiKey)
            DeleteButton()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
        .padding()
    }
    
    @ViewBuilder
    func ApiKey(apiKey: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("API KEY")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.leading)
            
            SecureField("Enter API Key", text: apiKey)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .font(.body)
                .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    func DeleteButton() -> some View {
        Button(action: {
            Task {
                try await core.conversationPersistenceService.deleteAll()
            }
        }) {
            Text("Delete All")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: 200)
                .background(Color.red)
                .cornerRadius(8)
        }
        .padding(.horizontal)
    }
}


//#Preview {
//    SidebarView()
//}
