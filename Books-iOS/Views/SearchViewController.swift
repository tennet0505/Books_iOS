//
//  SrarchViewController.swift
//  Books-iOS
//
//  Created by Oleg Ten on 15/10/2024.
//

import UIKit
import Combine

class SearchViewController: BaseViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = SearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.returnKeyType = .search
        setupBindings()
        viewModel.fetchBooks()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }
   
    private func setupBindings() {
        viewModel.$filteredBooks
            .sink { [weak self] books in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                self?.tableView.isHidden = books.isEmpty
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
        tableView.endEditing(true)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        searchBar.text = ""
        viewModel.searchQuery = ""
        view.endEditing(true)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        cell.config(book: viewModel.filteredBooks[indexPath.row])
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchQuery = searchText
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        if let query = searchBar.text, !query.isEmpty {
            performSearch(for: query)
        }
    }
    
    func performSearch(for query: String) {
        viewModel.searchQuery = query
    }
}
