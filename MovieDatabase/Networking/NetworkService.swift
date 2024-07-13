//
//  NetworkService.swift
//  MovieDatabase
//
//  Created by Sandeep kushwaha on 13/07/24.
//

import Foundation

enum NetworkError: String, Error {
    case SomethingWentWrong
}

protocol NetworkService {
    func fetchData<T: Decodable>(with request: URLRequest?) async throws -> T
}
