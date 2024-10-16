//
//  API.swift
//  Books-iOS
//
//  Created by Oleg Ten on 11/10/2024.
//

import Foundation
import Combine

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
}

protocol APIServiceProtocol {
    func fetchBooks() -> AnyPublisher<[Book], APIError>
}

class APIService: APIServiceProtocol {
    static let shared = APIService()
    private let url = MyURL.books.url
    
    init() {}
    
    func fetchBooks() -> AnyPublisher<[Book], APIError> {
        guard let url = URL(string: url) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Book].self, decoder: JSONDecoder())
            .mapError { error in
                if error is URLError {
                    return .requestFailed
                } else {
                    return .decodingFailed
                }
            }
            .handleEvents(receiveOutput: { books in
                self.saveBooksToDB(books: books)
            })
            .catch { (error: APIError) in
                return self.fetchBooksFromDB()
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchBooksFromDB() -> AnyPublisher<[Book], APIError> {
        return Future { promise in
            let bookEntities = CoreDataManager.shared.fetchBooks()
            
            let books = bookEntities.map { bookEntity in
                Book(
                    id: bookEntity.id ?? "",
                    title: bookEntity.title ?? "",
                    author: bookEntity.author ?? "",
                    imageUrl: bookEntity.imageUrl ?? "",
                    bookDescription: bookEntity.bookDescription ?? "",
                    isFavorite: bookEntity.isFavorite,
                    isPopular: bookEntity.isPopular,
                    pdfUrl: bookEntity.pdfUrl ?? ""
                )
            }
            
            promise(.success(books))
        }
        .setFailureType(to: APIError.self)
        .eraseToAnyPublisher()
    }
    
    private func saveBooksToDB(books: [Book]) {
        let existingFavoriteIDs = CoreDataManager.shared.fetchFavoriteBooks().map { $0.id ?? "" }
        CoreDataManager.shared.removeAllBooks()
        books.forEach { book in
            let isFavorite = existingFavoriteIDs.contains(book.id)
            CoreDataManager.shared.addOrUpdateBook(id: book.id,
                                                   title: book.title,
                                                   author: book.author,
                                                   imageUrl: book.imageUrl,
                                                   bookDescription: book.bookDescription,
                                                   isFavorite: isFavorite,
                                                   pdfUrl: book.pdfUrl,
                                                   isPopular: book.isPopular)
        }
    }
}
