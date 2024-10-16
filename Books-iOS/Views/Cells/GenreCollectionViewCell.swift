//
//  GenreCollectionViewCell.swift
//  Books-iOS
//
//  Created by Oleg Ten on 16/10/2024.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
        
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var genreImageView: UIImageView!
    
    func config(_ genre: Genre) {
        genreLabel.text = genre.title
        genreImageView.image = UIImage(named: genre.image)
    }
}
