import SwiftUI

struct BookDetail: View {
    let book: Book

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(.systemBackground), Color(.systemGray6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                // Imagen con estilo de tarjeta
                CachedAsyncImage(url: book.coverUrl, width: 320, height: 500)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                    .padding(.top, 40)
                
                // Información del libro
                VStack(spacing: 5) {
                    BookInfoView(book:book)
                }
                
                Spacer()
                
                
                GradientButton(title: "Continue Reading", destination: {
                    PDFKitView(url: book.pdfUrl)
                })
                
                
                    .padding(.bottom, 40)
                }
            }
            .padding(.horizontal)
        }
    }


#Preview {
    BookDetail(book: Book(
        id: 1,
        name: "Harry Potter and the Goblet of Fire",
        author: "J.K. Rowling",
        pdfUrl: "",
        coverUrl: "https://static.posters.cz/image/1300/214929.jpg"
    ))
}
