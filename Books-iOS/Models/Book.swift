//
//  Book.swift
//  Books-iOS
//
//  Created by Oleg Ten on 11/10/2024.
//

import Foundation

struct Book: Decodable {
    var id: String
    var title: String
    var author: String
    var imageUrl: String
    var description: String
    var isFavorite: Bool? = false
}

