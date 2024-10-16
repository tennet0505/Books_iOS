//
//  Book.swift
//  Books-iOS
//
//  Created by Oleg Ten on 11/10/2024.
//

import Foundation

struct BooksResponse: Decodable {
    var popularBooks: [Book]
    var newBooks: [Book]
}

struct Book: Decodable {
    var id: String
    var title: String
    var author: String
    var imageUrl: String
    var bookDescription: String
    var isFavorite: Bool? = false
    var isPopular: Bool = false
    var pdfUrl: String
}

struct Genre: Decodable {
    var title: String
    var image: String
}
