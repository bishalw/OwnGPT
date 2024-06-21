//
//  SideBarView.swift
//  OwnGpt
//
//  Created by Bishalw on 6/20/24.
//

import SwiftUI

struct SideBarView: View {
    var body: some View {
        VStack {
            
            // Ensure the HStack stretches to the full width
            
            Spacer()
            
            ForEach(1..<5) { row in
                Text("Row dslfas lfasdflsdflasdfajsldfajlsdflsd \(row)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            
            Spacer()
            
            HStack {
                Circle()
                    .frame(width: 50, height: 50)
                    .padding(.leading, 10) // Left padding
                    .padding(.bottom, 20)
                
                Text("John Smith")
                    .font(.headline)
                    .padding(.bottom, 20)
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "gear")
                        .imageScale(.large)
                        .padding(.trailing)
                        .padding(.bottom, 20)
                })
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    SideBarView()
}
