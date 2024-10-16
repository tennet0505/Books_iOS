//
//  ViewModel.swift
//  Books-iOS
//
//  Created by Oleg Ten on 11/10/2024.
//

import Foundation
import Combine

class BookViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var popularBooks: [Book] = []
    @Published var newBooks: [Book] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
    var apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    
    func fetchBooks(isLoading: Bool = false) {
        self.isLoading = isLoading
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
                self.reapplyFavorites(existingFavoriteIDs)
                self.filterAllBooks()
            })
            .store(in: &cancellables)
    }
    
    private func filterAllBooks() {
        let popularBooksFiltered = CoreDataManager.shared.fetchBooks()
            .filter{ $0.isPopular }
            .map { $0.convertToBook() }
        
        let newBooksFiltered = CoreDataManager.shared.fetchBooks()
            .filter{ !$0.isPopular }
            .map { $0.convertToBook() }
        popularBooks = popularBooksFiltered
        newBooks = newBooksFiltered
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
    
    func toggleFavoriteStatus(for book: Book) {
        let updatedBook = book
        
        // Update Core Data
        CoreDataManager.shared.updateBook(book: updatedBook, isFavorite: updatedBook.isFavorite ?? false)
        
        // Update the local books array
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books[index] = updatedBook
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
    
    func fetchBookGenres() -> [Genre] {
        var genreArray: [Genre] = [Genre(title: "Fantasy", image: "logoGenre"),
                                   Genre(title: "Fantazy", image: "logoGenre"),
                                   Genre(title: "Mystery", image: "logoGenre"),
                                   Genre(title: "Horror", image: "logoGenre"),
                                   Genre(title: "Novel", image: "logoGenre"),
                                   Genre(title: "Biography", image: "logoGenre"),
                                   Genre(title: "Humor", image: "logoGenre")]
        return genreArray
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
