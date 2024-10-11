//
//  ViewController.swift
//  Books-iOS
//
//  Created by Oleg Ten on 11/10/2024.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let viewModel = BookViewModel()
    private var cancellables = Set<AnyCancellable>()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Books"
        searchBar.delegate = self
        setupCollectionView()
        setupBindings()
        viewModel.fetchBooks()
        
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func setupBindings() {
        // Observe filteredBooks, not books
        viewModel.$filteredBooks
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
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
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
        cell.configure(with: viewModel.filteredBooks[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = viewModel.filteredBooks[indexPath.row]
        let storyboard =  UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        vc.bookId = book.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let width = collectionView.frame.width / 2 - layout.minimumInteritemSpacing
        
        return CGSize(width: width, height: width * 1.5)
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchQuery = searchText
    }
}

