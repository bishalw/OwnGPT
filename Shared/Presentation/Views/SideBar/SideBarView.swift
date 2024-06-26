//
//  SideBarView.swift
//  OwnGpt
//
//  Created by Bishalw on 6/20/24.
//

import SwiftUI

struct SidebarView: View {
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    @EnvironmentObject var core: Core

    let menuItems = [
        MenuItem(icon: "person", text: "Profile"),
        MenuItem(icon: "gear", text: "Settings"),
        MenuItem(icon: "info.circle", text: "About"),
        MenuItem(icon: "message", text: "Conversations") // Added Conversations menu item
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    SearchableView(searchText: $searchText, isSearching: $isSearching, placeholder: "Search")
                }
                .padding(.top, -10)
                Button("Delete All") {
                    Task{
                        try await core.conversationPersistenceService.deleteAll()
                    }
                }
                ConversationsView(conversationsViewModel: ConversationsViewModel(conversationsStore: core.conversationsStore))
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
    }

}
struct SearchableView: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    let placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .accessibility(hidden: true)
            
            TextField(placeholder, text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .accessibilityLabel("Search")
                .accessibilityHint("Enter text to search menu items")
                .onTapGesture {
                    isSearching = true
                }
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                    isSearching = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .accessibilityLabel("Clear search")
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isSearchField)
    }
}

struct MenuItem: Identifiable {
    let id = UUID()
    let icon: String
    let text: String
}

struct MenuItemView: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(text)
        }
    }
}

struct HamburgerButton: View {
    @Binding var showMenu: Bool
    @Binding var offset: CGFloat
    let sidebarWidth: CGFloat
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation(.easeOut(duration: 0.3)) {
                        if offset == 0 {
                            offset = sidebarWidth
                            showMenu = true
                        } else {
                            offset = 0
                            showMenu = false
                        }
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .imageScale(.large)
                }
                Spacer()
            }
            Spacer()
        }
    }
}

//#Preview {
//    SidebarView()
//}
