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
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = true
            navigationBar.backgroundColor = .clear
            navigationBar.tintColor = .white
        }
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
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in
                print("Share action")
            }
            
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                print("Delete action")
            }
            
            return UIMenu(title: "", children: [shareAction, deleteAction])
        }
    }
}

