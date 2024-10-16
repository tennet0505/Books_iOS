//
//  BaseViewController.swift
//  Books-iOS
//
//  Created by Oleg Ten on 15/10/2024.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}

extension BaseViewController: UIContextMenuInteractionDelegate {

    // Method to provide the actual context menu when long-pressing the icon
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {

        // Return a UIContextMenuConfiguration object
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in

            let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in
                print("Share action")
            }

            // Add more actions as needed
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                print("Delete action")
            }

            // Return the constructed menu
            return UIMenu(title: "", children: [shareAction, deleteAction])
        }
    }
}

