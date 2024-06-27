//
//  SideBarView.swift
//  OwnGpt
//
//  Created by Bishalw on 6/20/24.
//

import SwiftUI

struct SidebarView: View {
    
    @State private var searchText = ""
    @Binding var isSearching: Bool
    @FocusState private var isSearchFieldFocused: Bool
    @EnvironmentObject var core: Core
    @State private var isSettingsPresented = false
    @State var apiKey: String = Constants.apiKey
    
//    @StateObject var vm: SideBarViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 20) {
                searchBar
                conversationsView
                Spacer()
                settingsButton
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

// MARK: Subviews
extension SidebarView {
    private var searchBar: some View {
        SearchableView(
            searchText: $searchText,
            isSearching: $isSearching,
            placeholder: "Search",
            isSearchFieldFocused: $isSearchFieldFocused
        )
        .padding(.top, -10)
    }
    
    private var conversationsView: some View {
        ConversationsView(conversationsViewModel: ConversationsViewModel(conversationsStore: core.conversationsStore))
    }
    
    private var settingsButton: some View {
        SiderBarBottomView()
            .onTapGesture {
                isSettingsPresented.toggle()
            }
            .sheet(isPresented: $isSettingsPresented) {
                SettingsView(apiKey: $apiKey)
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
        HStack {
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
        }.padding(.bottom,16)
    }
}

struct SettingsView: View {
    @EnvironmentObject var core: Core
    @Binding var apiKey: String
    
    var body: some View {
        VStack(spacing: 20) {
            apiKey(apiKey: $apiKey)
            deleteButton()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
        .padding()
    }
    
    @ViewBuilder
    func apiKey(apiKey: Binding<String>) -> some View {
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
    func deleteButton() -> some View {
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




#Preview {
//    SidebarView(isSearching: .constant(false))
    EmptyView()
}
