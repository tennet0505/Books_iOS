//
//  Extentions.swift
//  Books-iOS
//
//  Created by Oleg Ten on 15/10/2024.
//
import UIKit
import SwiftUICore

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

extension UICollectionViewCell {
    func configureShadow() {
        self.layer.shadowColor = UIColor.black.cgColor // Color of the shadow
        self.layer.shadowOpacity = 0.3 // Opacity of the shadow (0.0 to 1.0)
        self.layer.shadowOffset = CGSize(width: 4, height: 4) // Shadow's offset (position)
        self.layer.shadowRadius = 4 // Blurriness of the shadow
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
