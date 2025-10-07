import Foundation

enum BookServiceError: Error {
    case invalidURL
    case httpError(Int, String?)
    case networkError(Error)
    case fileAccessError
}

final class BookService {
    private let baseURL = "http://localhost:8080"
    
    func getAllBooks() async -> [Book] {
        guard let url = URL(string: baseURL + "/getAllBooks") else {
            print("❌ URL inválida")
            return []
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let parsedData = try? JSONDecoder().decode([Book].self, from: data) {
                return parsedData
            } else {
                print("❌ Error parsing data")
                return []
            }
        } catch {
            print("❌ Error fetching books:", error)
            return []
        }
    }
    
    // ✅ Enviar con multipart/form-data (como espera tu servidor)
    func saveBookWithFiles(name: String, author: String, imageData: Data?, pdfData: Data?) async throws {
        guard let url = URL(string: baseURL + "/createBook") else {
            throw BookServiceError.invalidURL
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // ✅ Agregar campo "name"
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n")
        body.append("\(name)\r\n")
        
        // ✅ Agregar campo "author"
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"author\"\r\n\r\n")
        body.append("\(author)\r\n")
        
        // ✅ Agregar imagen (cover) si existe
        if let imageData = imageData {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"cover\"; filename=\"cover.jpg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(imageData)
            body.append("\r\n")
        }
        
        // ✅ Agregar PDF si existe
        if let pdfData = pdfData {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"pdf\"; filename=\"book.pdf\"\r\n")
            body.append("Content-Type: application/pdf\r\n\r\n")
            body.append(pdfData)
            body.append("\r\n")
        }
        
        // ✅ Cerrar el boundary
        body.append("--\(boundary)--\r\n")
        
        request.httpBody = body
        
        print("📤 Enviando libro: \(name) por \(author)")
        print("📦 Tamaño total: \(body.count) bytes")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw BookServiceError.networkError(NSError(domain: "Invalid response", code: -1))
            }
            
            print("📡 Código de respuesta:", httpResponse.statusCode)
            
            // Verificar si fue exitoso (200-299)
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorMessage = String(data: data, encoding: .utf8)
                print("❌ Error del servidor:", errorMessage ?? "Sin mensaje")
                throw BookServiceError.httpError(httpResponse.statusCode, errorMessage)
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("✅ Libro guardado exitosamente:", responseString)
            }
            
        } catch let error as BookServiceError {
            throw error
        } catch {
            print("❌ Error en la petición:", error)
            throw BookServiceError.networkError(error)
        }
    }
}

// ✅ Extension helper para Data
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
