//
//  FavoriteCollectionViewCell.swift
//  Books-iOS
//
//  Created by Oleg Ten on 16/10/2024.
//

import UIKit

protocol FavoriteViewCellDelegate: AnyObject {
    func didTapShare(for book: Book)
    func didTapRemove(in cell: FavoriteCollectionViewCell)
}

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var bottomTitleLabel: UILabel!
    @IBOutlet weak var bottomAuthor: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var menuButton: UIButton!
    weak var delegate: FavoriteViewCellDelegate?
    var book: Book?
    
    func configure(with book: Book) {
        self.book = book
        let url = URL(string: book.imageUrl)
        imageView.kf.setImage(with: url)
        titleLabel.text = book.title
        author.text = book.author
        bottomTitleLabel.text = book.title
        bottomAuthor.text = book.author
        menuButton.setImage(UIImage(named: "icon_menu"), for: .normal)
        menuButton.tintColor = .gray
        configureShadow()
        configureMenu()
        
    }
    private func configureMenu() {
        guard let book = self.book else { return }
        let favoriteAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
            self.delegate?.didTapShare(for: book)
        }
        
        let deleteAction = UIAction(title: "Remove from favorites", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            self.delegate?.didTapRemove(in: self)
        }
        
        let menu = UIMenu(title: "", children: [favoriteAction, deleteAction])
        menuButton.menu = menu
        menuButton.showsMenuAsPrimaryAction = true
    }
}
