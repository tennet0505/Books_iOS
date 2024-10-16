//
//  BookCollectionViewCell.swift
//  Books-iOS
//
//  Created by Oleg Ten on 11/10/2024.
//

import UIKit
import Kingfisher

protocol BookCellDelegate: AnyObject {
    func didTapFavoriteButton(in cell: BookCell)
}

class BookCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var bottomTitleLabel: UILabel!
    @IBOutlet weak var bottomAuthor: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var favButton: UIButton!
    
    weak var delegate: BookCellDelegate?
    
    func configure(with book: Book) {
        let url = URL(string: book.imageUrl)
        let imageName = book.isFavorite ?? false ? "heart.fill" : "heart"
        let heartImage = UIImage(systemName: imageName)
        imageView.kf.setImage(with: url)
        titleLabel.text = book.title
        author.text = book.author
        bottomTitleLabel.text = book.title
        bottomAuthor.text = book.author
        configureShadow()
        favButton.setImage(heartImage, for: .normal)
        favButton.tintColor = book.isFavorite ?? false ? .red : .gray
        favButton.addTarget(self, action: #selector(favButtonTapped), for: .touchUpInside)
    }
    
    @objc func favButtonTapped() {
            delegate?.didTapFavoriteButton(in: self)
    }
}
