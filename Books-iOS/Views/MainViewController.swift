//
//  ViewController.swift
//  Books-iOS
//
//  Created by Oleg Ten on 11/10/2024.
//

import UIKit
import Combine
import SVProgressHUD

class MainViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newBooksCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let viewModel = BookViewModel()
    private var cancellables = Set<AnyCancellable>()    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        viewModel.fetchBooks(isLoading: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoriteStatusChanged(_:)), name: NSNotification.Name("FavoriteStatusChanged"), object: nil)
    }
    
    @objc func handleFavoriteStatusChanged(_ notification: Notification) {
        viewModel.fetchBooks()
    }
        
    private func setupBindings() {
        viewModel.$popularBooks
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$newBooks
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.newBooksCollectionView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .sink { [weak self] errorMessage in
                if let message = errorMessage {
                    self?.showErrorAlert(message: message)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .sink { isLoading in
                if isLoading {
                    SVProgressHUD.show()
                } else {
                    SVProgressHUD.dismiss()
                }
            }
            .store(in: &cancellables)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        tabBarController?.selectedIndex = 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return  viewModel.popularBooks.count
        }
        if collectionView == self.newBooksCollectionView {
            return viewModel.newBooks.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
            cell.configure(with: viewModel.popularBooks[indexPath.row])
            return cell
        }
        if collectionView == self.newBooksCollectionView {
            let cell = newBooksCollectionView.dequeueReusableCell(withReuseIdentifier: "NewBookCollectionViewCell", for: indexPath) as! NewBookCollectionViewCell
            cell.configure(with: viewModel.newBooks[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard =  UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        if collectionView == self.collectionView {
            let book = viewModel.popularBooks[indexPath.row]
            vc.bookId = book.id
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if collectionView == self.newBooksCollectionView {
            let book = viewModel.newBooks[indexPath.row]
            vc.bookId = book.id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: 200, height: 300)
        }
        if collectionView == self.newBooksCollectionView {
            return CGSize(width: 150, height: 200)
        }
        return CGSize(width: 0, height: 0)
    }
}

