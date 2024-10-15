//
//  Constants.swift
//  Books-iOS
//
//  Created by Oleg Ten on 12/10/2024.
//

import Foundation

enum MyURL {
    case books
    case allBooks
    case authors

    var url: String {
        switch self {
        case .books:
            return "\(API.baseURL)books"
        case .allBooks:
            return "\(API.baseURL)allBooks"
        case .authors:
            return "\(API.baseURL)authors"
        }
    }
}

struct API {
    static let baseURL = "https://6708f864af1a3998ba9fdd2f.mockapi.io/api/v1/"
}
