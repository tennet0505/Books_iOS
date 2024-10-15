//
//  SearchTableViewCell.swift
//  Books-iOS
//
//  Created by Oleg Ten on 15/10/2024.
//

import UIKit
import Kingfisher

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(book: Book) {
        let url = URL(string: book.imageUrl)
        bookImageView.kf.setImage(with: url)
        titleLabel.text = book.title
        authorLabel.text = book.author
    }

}
