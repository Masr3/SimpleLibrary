//
//  GradientButton.swift
//  SimpleLibrary
//
//  Created by Manuel Alejandro Santana Ramirez on 5/10/25.
//

import SwiftUI

struct GradientButton<Destination:View>: View {
    
    let title: String
    let gradient: Gradient
    let width: CGFloat
    let height: CGFloat
   @ViewBuilder var destination:Destination
    
    init(
        title: String,
        gradient: Gradient = Gradient(colors: [Color.blue, Color.purple]),
        width: CGFloat = 300,
        height: CGFloat = 50,
        @ViewBuilder destination: () -> Destination
    ) {
        self.title = title
        self.gradient = gradient
        self.width = width
        self.height = height
        self.destination = destination()
    }
    
    
    
    var body: some View {
        
        NavigationLink(destination: destination) {
            Text(title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: width, height: height)
                .background(
                    LinearGradient(
                        gradient: gradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
                .shadow(color: .purple.opacity(0.3), radius: 6, x: 0, y: 3)
        }
    }
}

//#Preview {
//    GradientButton()
//}
