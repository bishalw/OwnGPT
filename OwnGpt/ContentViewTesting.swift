//
//  ContentView.swift
//  OwnGpt
//
//  Created by Bishalw on 6/22/23.
//

import SwiftUI

struct ContentViewTesting: View {
    @State var text = ""
    var body: some View {
        VStack {
                HStack {
                
                    Image(systemName: "brain")
                    Text("OwnGpt: ")
                    TextField("Talk to me ", text: $text).onSubmit {
                        
                    }
                }
        }
        .padding()
        
    }
}

#Preview {
    ContentViewTesting()
}

