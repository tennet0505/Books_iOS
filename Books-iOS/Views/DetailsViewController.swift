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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let book = book else { return }
        print(book.title)
        titleLabel.text = book.title
        descriptionLabel.text = book.description
//        if book.isFavorite ?? <#default value#> {
//            favButton.setImage(.checkmark, for: .normal)
//        } else {
//            favButton.setImage(.none, for: .normal)
//        }
    }
    
    @IBAction func favoriteButtonAction(_ sender: Any) {
        
    }
    
}
