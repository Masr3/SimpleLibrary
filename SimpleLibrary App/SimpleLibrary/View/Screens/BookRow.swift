//
//  BookRow.swift
//  SimpleLibrary
//
//  Created by Manuel Alejandro Santana Ramirez on 4/10/25.
//

import SwiftUI

struct BookRow: View {
    
    let book:Book
        
    var body: some View {
        
        HStack{
            
            CachedAsyncImage(url:book.coverUrl, width: 80, height:120)
            
            
            
            Text(book.name)
                .font(.title3)
        }
        .padding()
        
    }
}

#Preview {
    BookRow(book:Book(
        id:1,
        name:"Harry Potter and the Goblet of Fire",
        author:"Yuval Noaḥ Harari",
        pdfUrl: "",
        coverUrl: "https://static.posters.cz/image/1300/214929.jpg"
        
    ))
}
