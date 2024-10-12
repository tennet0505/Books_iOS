//
//  Constants.swift
//  Books-iOS
//
//  Created by Oleg Ten on 12/10/2024.
//

import Foundation

enum MyURL {
    case books
    case bestSellers
    case authors

    var url: String {
        switch self {
        case .books:
            return "\(API.baseURL)books"
        case .bestSellers:
            return "\(API.baseURL)best-sellers"
        case .authors:
            return "\(API.baseURL)authors"
        }
    }
}

struct API {
    static let baseURL = "https://6708f864af1a3998ba9fdd2f.mockapi.io/api/v1/"
}
