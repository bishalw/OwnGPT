//
//  ContentView.swift
//  OwnGpt
//
//  Created by Bishalw on 6/22/23.
//

import SwiftUI

struct ContentView: View {
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
    ContentView()
}



    
/**
 
 Task  {
     let api = ChatGPTAPI(apiKey: Constants.apiKey)
     do {
         let stream = try await  api.sendMessageStream(text: text)
         for try await line in stream {
             print(line)
         }
         print(stream)
     } catch {
         print(error.localizedDescription)
     }
 }
 */
