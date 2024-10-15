//
//  SearchViewModel.swift
//  Books-iOS
//
//  Created by Oleg Ten on 15/10/2024.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var filteredBooks: [Book] = []
    @Published var searchQuery: String = ""
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
    var apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
        setupBindings()
    }
    
    func fetchFavBooks() {
        let booksFiltered = CoreDataManager.shared.fetchFavoriteBooks().map { $0.convertToBook() }
        books = booksFiltered
        filteredBooks = booksFiltered
    }
    
    func fetchBooks() {
        isLoading = true
        let existingFavoriteIDs = fetchFavoriteBookIDs()
        
        apiService.fetchBooks()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    // Completed successfully
                    break
                case .failure(let error):
                    self.errorMessage = self.handleError(error)
                }
            }, receiveValue: { [weak self] books in
                guard let self = self else { return }
                self.books = books
                self.filteredBooks = books
                self.reapplyFavorites(existingFavoriteIDs)
            })
            .store(in: &cancellables)
    }
    
    private func fetchFavoriteBookIDs() -> Set<String> {
        let booksFiltered = CoreDataManager.shared.fetchFavoriteBooks().map { $0.id ?? "" }
        return Set(booksFiltered)
    }
    
    private func reapplyFavorites(_ favoriteIDs: Set<String>) {
        for id in favoriteIDs {
            if let index = books.firstIndex(where: { $0.id == id }) {
                books[index].isFavorite = true // Reapply favorite status
            }
        }
    }
    
    private func setupBindings() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.filterBooks(query: query)
            }
            .store(in: &cancellables)
    }
    
    func filterBooks(query: String) {
        if query.isEmpty {
            filteredBooks = books
        } else {
            filteredBooks = books.filter { book in
                let titleMatches = book.title.lowercased().contains(query.lowercased())
                let authorMatches = book.author.lowercased().contains(query.lowercased())
                return titleMatches || authorMatches
            }
        }
    }
    
    func toggleFavoriteStatus(for book: Book) {
        let updatedBook = book
        
        // Update Core Data
        CoreDataManager.shared.updateBook(book: updatedBook, isFavorite: updatedBook.isFavorite ?? false)
        
        // Update the local books array
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books[index] = updatedBook
            filteredBooks[index] = updatedBook
        }
    }
    
    func fetchBookById(_ id: String) -> Book? {
        if let bookEntity = CoreDataManager.shared.fetchBookByID(id) {
            print(bookEntity)
            return bookEntity.convertToBook()
        } else {
            return nil
        }
    }
    
    private func handleError(_ error: APIError) -> String {
        switch error {
        case .invalidURL:
            return "Invalid URL."
        case .requestFailed:
            return "Network request failed."
        case .decodingFailed:
            return "Failed to decode response."
        }
    }
    
}

