//
//  DetailsViewController.swift
//  Books-iOS
//
//  Created by Oleg Ten on 11/10/2024.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var book: Book? = nil
    var isFavorite: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let book = book else { return }
        print(book.title)
        titleLabel.text = book.title
        descriptionLabel.text = book.bookDescription
        isFavorite = book.isFavorite ?? false
        setupFavoriteButton()
    }
    
    @IBAction func favoriteButtonAction(_ sender: Any) {
        guard let book = book else { return }
        isFavorite.toggle()
        setupFavoriteButton()
    }
    
    func setupFavoriteButton() {
        let imageName = isFavorite ? "heart.fill" : "heart"
        favButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
}
