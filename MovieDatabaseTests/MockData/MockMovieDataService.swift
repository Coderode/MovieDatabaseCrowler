//
//  MockDataService.swift
//  MovieDatabaseTests
//
//  Created by Sandeep kushwaha on 27/07/24.
//

import XCTest
@testable import MovieDatabase

class MockMovieDataService: NetworkService {
    enum MockMovieDataServiceError: String, Error {
        case jsonFileNotFound
    }
    func fetchData<T>(with request: URLRequest?) async throws -> T where T : Decodable {
        return try self.fetchLocalJsonData()
    }
    
    private func fetchLocalJsonData<T: Decodable>() throws -> T {
        // Locate the JSON file in the bundle
        if let url = Bundle(for: type(of: self)).url(forResource: "MockMovies", withExtension: "json") {
            // Read the file content
            let data = try Data(contentsOf: url)
            // Decode the JSON data
            let decoder = JSONDecoder()
            let movies = try decoder.decode(T.self, from: data)
            return movies
        } else {
            throw MockMovieDataServiceError.jsonFileNotFound
        }
    }
}
