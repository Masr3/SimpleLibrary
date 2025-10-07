//
//  BookList.swift
//  SimpleLibrary
//
//  Created by Manuel Alejandro Santana Ramirez on 4/10/25.
//
//
//  BookList.swift
//  SimpleLibrary
//
//  Created by Manuel Alejandro Santana Ramirez on 4/10/25.
//

import SwiftUI

struct BookList: View {
    @State private var books: [Book] = []
    @StateObject private var bookViewModel = BookViewModel()
    
    
    var body: some View {
        
        NavigationSplitView {
    
            List(bookViewModel.filteredBooks) { book in
                NavigationLink {
                    BookDetail(book: book)
                } label: {
                    BookRow(book: book)
                }
            }
            .navigationTitle("Books")
            .toolbar{
                GradientButton(title: "Add book", width:120, height: 40, destination: {
                    BookForm()
                })
            }
            .task {
                 await bookViewModel.fetchBooks()
            }
            .searchable(text: $bookViewModel.searchQuery, prompt: "Search Books")
        } detail: {
            Text("Select a Book")
                .foregroundColor(.gray)
        }
    }
    

}

#Preview {
    BookList()
}




