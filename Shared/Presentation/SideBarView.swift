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
    
    let menuItems = [
        MenuItem(icon: "house", text: "Home"),
        MenuItem(icon: "person", text: "Profile"),
        MenuItem(icon: "gear", text: "Settings"),
        MenuItem(icon: "info.circle", text: "About")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack{
                SearchableView(searchText: $searchText, isSearching: $isSearching, placeholder: "Search")
//                Button("Cancel") {
//                    
//                }
            }
            
                .padding(.top, -10)
                List {
                    ForEach(filteredMenuItems) { item in
                        MenuItemView(icon: item.icon, text: item.text)
                    }
                }
                .listStyle(PlainListStyle())
                .accessibilityLabel("Search results")
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
    }
    
    var filteredMenuItems: [MenuItem] {
        if searchText.isEmpty {
            return menuItems
        } else {
            return menuItems.filter { $0.text.localizedCaseInsensitiveContains(searchText) }
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
