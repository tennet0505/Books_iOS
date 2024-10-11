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

class APIService {
    static let shared = APIService()
    private let baseUrl = "https://6708f864af1a3998ba9fdd2f.mockapi.io/api/v1/books"
    
    init() {}
    
    func fetchBooks() -> AnyPublisher<[Book], APIError> {
        guard let url = URL(string: baseUrl) else {
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
            .eraseToAnyPublisher()
    }
}
