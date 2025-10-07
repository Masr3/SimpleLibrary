//
//  Book.swift
//  SimpleLibrary
//
//  Created by Manuel Alejandro Santana Ramirez on 4/10/25.
//

import Foundation

struct Book: Codable, Hashable, Identifiable {
    
    var id:Int64
    var name:String
    var author:String
    var pdfUrl:String
    var coverUrl:String
    
}
