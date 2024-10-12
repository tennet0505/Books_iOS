//
//  DetailsViewController.swift
//  Books-iOS
//
//  Created by Oleg Ten on 11/10/2024.
//

import UIKit
import Kingfisher

class DetailsViewController: UIViewController {

    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    private let viewModel = BookViewModel()
    var bookId: String?
    var isFavorite: Bool = false
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = bookId else { return }
        book = viewModel.fetchBookById(id)
        let url = URL(string: book?.imageUrl ?? "")
        imageView.kf.setImage(with: url)
        descriptionLabel.text = book?.bookDescription
        isFavorite = book?.isFavorite ?? false
        bookTitle.text = book?.title
        authorLabel.text = book?.author
        setupFavoriteButton()
    }
    
    @IBAction func favoriteButtonAction(_ sender: Any) {
        guard let book = book else { return }
        isFavorite.toggle()
        setupFavoriteButton()
        var favoriteBook = book
        favoriteBook.isFavorite = isFavorite
        viewModel.toggleFavoriteStatus(for: favoriteBook)        
    }
    
    func setupFavoriteButton() {
        let imageName = isFavorite ? "heart.fill" : "heart"
        favButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
}
