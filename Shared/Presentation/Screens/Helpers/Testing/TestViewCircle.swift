//
//  TestViewCircle.swift
//  OwnGpt
//
//  Created by Bishalw on 7/1/24.
//

import SwiftUI

struct TestViewCircle: View {
    @State private var isLogoExpanded = true
    
    var body: some View {
        VStack {
            CircularLogoView(circleColor: .blue, diameter: 300, isExpanded: $isLogoExpanded)
            Button("Toggle Logo") {
                isLogoExpanded.toggle()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

struct TestViewCircle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TestViewCircle()
                .previewDisplayName("Default")
            
            TestViewCircle()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
            
            TestViewCircle()
                .previewLayout(.fixed(width: 200, height: 200))
                .previewDisplayName("Fixed Size")
            
            TestViewCircle()
                .previewDevice("iPhone 12")
                .previewDisplayName("iPhone 12")
        }
    }
}
