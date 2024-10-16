//
//  MyLibraryViewController.swift
//  Books-iOS
//
//  Created by Oleg Ten on 12/10/2024.
//

import UIKit
import Combine

class MyLibraryViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cancelButton: UIButton!

    private let viewModel = MyLibraryViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.isHidden = true
        searchBar.delegate = self
        setupCollectionView()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchBooks()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func setupBindings() {
        viewModel.$filteredBooks
            .sink { [weak self] books in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
                self?.collectionView.isHidden = books.isEmpty
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        collectionView.endEditing(true)
    }
}

extension MyLibraryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionViewCell", for: indexPath) as! FavoriteCollectionViewCell
        cell.configure(with: viewModel.filteredBooks[indexPath.row])
        cell.delegate = self
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
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        cancelButton.isHidden = true
        searchBar.text = ""
        viewModel.searchQuery = ""
        view.endEditing(true)
    }
}

extension MyLibraryViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchQuery = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        cancelButton.isHidden = true
        if let query = searchBar.text, !query.isEmpty {
            performSearch(for: query)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        cancelButton.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        cancelButton.isHidden = true
    }
    
    func performSearch(for query: String) {
        viewModel.searchQuery = query
    }
}

extension MyLibraryViewController: FavoriteViewCellDelegate {
    
    func didTapRemove(in cell: FavoriteCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        var book = viewModel.filteredBooks[indexPath.row]
        book.isFavorite?.toggle()
        viewModel.filteredBooks[indexPath.row] = book
        viewModel.toggleFavoriteStatus(for: book)
        viewModel.fetchBooks()
    }
    
    func didTapShare(for book: Book) {
        let activityViewController = UIActivityViewController(activityItems: [book.title], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
}
