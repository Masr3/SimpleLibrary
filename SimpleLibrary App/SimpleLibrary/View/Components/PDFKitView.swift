//
//  PDFKitView.swift
//  SimpleLibrary
//
//  Created by Manuel Alejandro Santana Ramirez on 4/10/25.
//

import SwiftUI
import PDFKit

import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    let url: String

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        
        // Intentamos crear la URL
        guard let pdfURL = URL(string: url) else { return pdfView }

        if pdfURL.isFileURL {
            // ✅ PDF local (en disco o bundle)
            pdfView.document = PDFDocument(url: pdfURL)
        } else {
            // 🌐 PDF remoto — descargamos el archivo
            DispatchQueue.global(qos: .background).async {
                if let data = try? Data(contentsOf: pdfURL),
                   let document = PDFDocument(data: data) {
                    DispatchQueue.main.async {
                        pdfView.document = document
                    }
                } else {
                    print("⚠️ No se pudo cargar el PDF desde la URL: \(pdfURL)")
                }
            }
        }

        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}

#Preview {
    PDFKitView(url:"https://example.com/sample.pdf")
}
