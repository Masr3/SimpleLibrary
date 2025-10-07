import SwiftUI
import PDFKit
import PhotosUI

struct BookForm: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = BookViewModel()
    
    @State private var name: String = ""
    @State private var author: String = ""
    @State private var pdfURL: URL?
    
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var imageData: Data? // ✅ Guardar la imagen como Data
    @State private var showImporter = false
    @State private var isSaving = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Book Information") {
                    TextField("Book Name", text: $name)
                    TextField("Author", text: $author)
                }
                
                Section("Cover Image") {
                    PhotosPicker("Select a picture", selection: $pickerItem, matching: .images)
                    
                    if let selectedImage {
                        selectedImage
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                }
                .onChange(of: pickerItem) {
                    Task {
                        // ✅ Cargar tanto la imagen para preview como los datos
                        if let data = try? await pickerItem?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                // Comprimir imagen al 70% de calidad
                                imageData = uiImage.jpegData(compressionQuality: 0.7)
                                selectedImage = Image(uiImage: uiImage)
                            }
                        }
                    }
                }
                
                Section("PDF") {
                    Button("Open files") {
                        showImporter = true
                    }
                    .fileImporter(
                        isPresented: $showImporter,
                        allowedContentTypes: [.pdf],
                        allowsMultipleSelection: false
                    ) { result in
                        switch result {
                        case .success(let urls):
                            pdfURL = urls.first
                            if let fileUrl = pdfURL {
                                print("archivo adjunto \(fileUrl)✅")
                            }
                        case .failure(let error):
                            print("Error al adjuntar el archivo: \(error)❌")
                        }
                    }
                    
                    if let fileURL = pdfURL {
                        Text("Archivo: \(fileURL.lastPathComponent)")
                            .lineLimit(1)
                    }
                }
                
                Section {
                    Button(action: saveBook) {
                        HStack {
                            if isSaving {
                                ProgressView()
                                    .padding(.trailing, 8)
                            }
                            Text(isSaving ? "Saving..." : "Save Book")
                        }
                    }
                    .disabled(name.isEmpty || author.isEmpty || isSaving)
                }
            }
            .navigationTitle("Add Book")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func saveBook() {
        guard !name.isEmpty, !author.isEmpty else {
            errorMessage = "Please fill in all required fields"
            showError = true
            return
        }
        
        isSaving = true
        
        Task {
            do {
                // ✅ Leer el PDF como Data si existe
                var pdfData: Data?
                if let pdfURL = pdfURL {
                    // Necesitamos acceso seguro al archivo
                    guard pdfURL.startAccessingSecurityScopedResource() else {
                        throw NSError(domain: "FileAccess", code: -1, userInfo: [NSLocalizedDescriptionKey: "Cannot access PDF file"])
                    }
                    defer { pdfURL.stopAccessingSecurityScopedResource() }
                    
                    pdfData = try Data(contentsOf: pdfURL)
                }
                
                // ✅ Enviar al servidor con multipart
                try await viewModel.addBookWithFiles(
                    name: name,
                    author: author,
                    imageData: imageData,
                    pdfData: pdfData
                )
                
                isSaving = false
                dismiss()
                
            } catch {
                isSaving = false
                errorMessage = error.localizedDescription
                showError = true
                print("❌ Error guardando libro:", error)
            }
        }
    }
}

#Preview {
    BookForm()
}
