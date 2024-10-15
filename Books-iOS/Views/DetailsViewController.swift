//
//  DetailsViewController.swift
//  Books-iOS
//
//  Created by Oleg Ten on 11/10/2024.
//

import UIKit
import Kingfisher
import PDFKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bestNewLabel: UILabel!
    @IBOutlet weak var readBookButton: UIButton!
    
    private let viewModel = BookViewModel()
    var bookId: String?
    var isFavorite: Bool = false
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        guard let id = bookId else { return }
        book = viewModel.fetchBookById(id)
        let url = URL(string: book?.imageUrl ?? "")
        imageView.kf.setImage(with: url)
        descriptionLabel.text = book?.bookDescription
        isFavorite = book?.isFavorite ?? false
        bestNewLabel.text = (book?.isPopular ?? false) ? "Popular" : "New"
        bookTitle.text = book?.title
        authorLabel.text = book?.author
        readBookButton.isHidden = !isFavorite
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
    
    @IBAction func readButtonAction(_ sender: Any) {
        let pdfVC = storyboard?.instantiateViewController(withIdentifier: "PDFViewController") as! PDFViewController
        let urlString = book?.pdfUrl ?? ""
        pdfVC.pdfUrl = urlString
        self.present(pdfVC, animated: true, completion: nil)
    }
    
    func setupFavoriteButton() {
        let imageName = isFavorite ? "heart.fill" : "heart"
        let heartImage = UIImage(systemName: imageName)
        favButton.setImage(heartImage, for: .normal)
        favButton.tintColor = isFavorite ? .red : .gray
    }
}
