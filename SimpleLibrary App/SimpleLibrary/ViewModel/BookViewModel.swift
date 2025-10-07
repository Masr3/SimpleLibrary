import Foundation

@MainActor
final class BookViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var searchQuery: String = ""
    
    private let service = BookService()
    
    var filteredBooks: [Book] {
        guard !searchQuery.isEmpty else {
            return books
        }
        return books.filter {
            $0.name.lowercased().contains(searchQuery.lowercased())
        }
    }
    
    func fetchBooks() async {
        let fetched = await service.getAllBooks()
        self.books = fetched
    }
    
    // ✅ Nueva función para enviar archivos
    func addBookWithFiles(name: String, author: String, imageData: Data?, pdfData: Data?) async throws {
        try await service.saveBookWithFiles(
            name: name,
            author: author,
            imageData: imageData,
            pdfData: pdfData
        )
        await fetchBooks() // Refresca la lista después de guardar
    }
}
