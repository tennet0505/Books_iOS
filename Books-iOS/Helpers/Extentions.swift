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
        
        // Optional: Improves rendering performance by rasterizing the view
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

extension UIImageView {
    
    /// Adds a blur effect to the image view.
    /// - Parameter style: The UIBlurEffect style, defaults to `.light`.
    func addBlurEffect(style: UIBlurEffect.Style = .light) {
        // Remove any existing blur effect before adding a new one (if needed)
        removeBlurEffect()

        // Create a UIBlurEffect with the given style
        let blurEffect = UIBlurEffect(style: style)
        
        // Create a UIVisualEffectView to apply the blur effect
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // To fit the image view's size
        
        // Add the blur effect view on top of the image view
        self.addSubview(blurEffectView)
    }
    
    /// Removes any existing blur effect from the image view.
    func removeBlurEffect() {
        // Find and remove any UIVisualEffectView subviews
        subviews.forEach { subview in
            if let blurView = subview as? UIVisualEffectView {
                blurView.removeFromSuperview()
            }
        }
    }
}
