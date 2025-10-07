//
//  BookInfoView.swift
//  SimpleLibrary
//
//  Created by Manuel Alejandro Santana Ramirez on 5/10/25.
//

import SwiftUI

struct BookInfoView: View {
    
    var book:Book
    var body: some View {
        
        
        Text(book.name)
            .font(.title2)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .lineLimit(2)      
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal)
        
        
        Text("by \(book.author)")
            .font(.subheadline)
            .foregroundColor(.gray)    }
}

#Preview {
    BookInfoView(book: Book(
        id: 1,
        name: "Harry Potter and the Goblet of Fire",
        author: "J.K. Rowling",
        pdfUrl: "",
        coverUrl: "https://static.posters.cz/image/1300/214929.jpg"
    ))
}
