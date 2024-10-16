//
//  NewBookCollectionViewCell.swift
//  Books-iOS
//
//  Created by Oleg Ten on 15/10/2024.
//

import UIKit

protocol NewBookCollectionViewCellDelegate: AnyObject {
    func didTapFavoriteButton(in cell: NewBookCollectionViewCell)
}

class NewBookCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomTitleLabel: UILabel!
    @IBOutlet weak var bottomAuthor: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    weak var delegate: NewBookCollectionViewCellDelegate?
    
    func configure(with book: Book) {
        let url = URL(string: book.imageUrl)
        imageView.kf.setImage(with: url)
        titleLabel.text = book.title
        author.text = book.author
        let imageName = book.isFavorite ?? false ? "heart.fill" : "heart"
        let heartImage = UIImage(systemName: imageName)
        favButton.setImage(heartImage, for: .normal)
        favButton.tintColor = book.isFavorite ?? false ? .red : .gray
        favButton.addTarget(self, action: #selector(favButtonTapped), for: .touchUpInside)
    }
    
    @objc func favButtonTapped() {
        delegate?.didTapFavoriteButton(in: self)
    }
}
