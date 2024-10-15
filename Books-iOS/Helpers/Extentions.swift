//
//  Extentions.swift
//  Books-iOS
//
//  Created by Oleg Ten on 15/10/2024.
//
import Foundation

extension BookEntity {
    func convertToBook() -> Book {
        return Book(id: self.id ?? "",
                    title: self.title ?? "",
                    author: self.author ?? "",
                    imageUrl: self.imageUrl ?? "",
                    bookDescription: self.bookDescription ?? "",
                    isFavorite: self.isFavorite,
                    isPopular: self.isPopular,
                    pdfUrl: self.pdfUrl ?? ""
        )
    }
}
