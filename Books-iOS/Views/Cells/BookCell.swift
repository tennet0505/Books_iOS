//
//  BookCollectionViewCell.swift
//  Books-iOS
//
//  Created by Oleg Ten on 11/10/2024.
//

import UIKit
import Kingfisher

class BookCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var bottomTitleLabel: UILabel!
    @IBOutlet weak var bottomAuthor: UILabel!
    @IBOutlet weak var favImageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    
    func configure(with book: Book) {
        let url = URL(string: book.imageUrl)
        let imageName = book.isFavorite ?? false ? "heart.fill" : "heart"
        let heartImage = UIImage(systemName: imageName)
        imageView.kf.setImage(with: url)
        titleLabel.text = book.title
        author.text = book.author
        bottomTitleLabel.text = book.title
        bottomAuthor.text = book.author
        favImageView.image = heartImage
        favImageView.tintColor = book.isFavorite ?? false ? .red : .gray
        configureShadow()
    }
}
