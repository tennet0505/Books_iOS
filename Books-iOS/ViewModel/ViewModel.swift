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
    @Published var filteredBooks: [Book] = []
    @Published var searchQuery: String = ""
    @Published var errorMessage: String? = nil

    private var cancellables = Set<AnyCancellable>()

    init() {
        setupBindings()
        fetchBooks()
    }
    
    private func fetchBooks() {
        APIService().fetchBooks()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    // Completed successfully
                    break
                case .failure(let error):
                    self.errorMessage = self.handleError(error)
                }
            }, receiveValue: { [weak self] books in
                self?.books = books
                self?.filteredBooks = books
            })
            .store(in: &cancellables)
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
            filteredBooks = books.filter { $0.title.lowercased().contains(query.lowercased()) }
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

