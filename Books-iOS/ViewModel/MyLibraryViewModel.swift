//
//  MyLibraryViewModel.swift
//  Books-iOS
//
//  Created by Oleg Ten on 12/10/2024.
//

import Foundation
import Combine
import SwiftUICore

class MyLibraryViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var filteredBooks: [Book] = []
    @Published var searchQuery: String = ""
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }
    
    func fetchBooks() {
        let allBooks = CoreDataManager.shared.fetchBooks().map{ $0.convertToBook() }
        books = allBooks
        filteredBooks = allBooks
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
    
    private func filterBooks(query: String) {
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
        
        print(updatedBook)
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
