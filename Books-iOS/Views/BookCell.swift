//
//  BookCollectionViewCell.swift
//  Books-iOS
//
//  Created by Oleg Ten on 11/10/2024.
//

import UIKit

class BookCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    func configure(with book: Book) {
        imageView.image = UIImage(named: "placeholder")
        titleLabel.text = book.title
//        if book.isFavorite {
//            favoriteImageView.image = .checkmark
//        } else {
//            favoriteImageView.image = .none
//        }
    }
}
