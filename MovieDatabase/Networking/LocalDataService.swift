//
//  LocalDataService.swift
//  MovieDatabase
//
//  Created by Sandeep kushwaha on 13/07/24.
//

import Foundation



struct LocalMovieDataService: NetworkService {
    enum LocalMovieDataServiceError: String, Error {
        case jsonFileNotFound
    }
    func fetchData<T>(with request: URLRequest?) async throws -> T where T : Decodable {
        return try self.fetchLocalJsonData()
    }
    
    private func fetchLocalJsonData<T: Decodable>() throws -> T {
        // Locate the JSON file in the bundle
        if let url = Bundle.main.url(forResource: "movies", withExtension: "json") {
            // Read the file content
            let data = try Data(contentsOf: url)
            // Decode the JSON data
            let decoder = JSONDecoder()
            let persons = try decoder.decode(T.self, from: data)
            return persons
        } else {
            throw LocalMovieDataServiceError.jsonFileNotFound
        }
    }
}
