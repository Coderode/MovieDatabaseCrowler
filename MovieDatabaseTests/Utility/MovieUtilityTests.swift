//
//  MovieUtilityTests.swift
//  MovieDatabaseTests
//
//  Created by Sandeep kushwaha on 27/07/24.
//

import XCTest
@testable import MovieDatabase

final class MovieUtilityTests: XCTestCase {
    var movies: Movies!
    var utility: MovieModelUtilityProtocol!
    override func setUp() {
        super.setUp()
        // load data
        if let url = Bundle(for: type(of: self)).url(forResource: "MockMovies", withExtension: "json") {
            // Read the file content
            do {
                let data = try Data(contentsOf: url)
                // Decode the JSON data
                let decoder = JSONDecoder()
                movies = try decoder.decode(Movies.self, from: data)
            } catch {
                movies = []
            }
        } else {
            movies = []
        }
        utility = MovieModelUtility()
    }
    
    override func tearDown() {
        super.tearDown()
        self.movies = nil
        self.utility = nil
    }
    
    func testProcessedGenreList() {
        let genreList = utility.getProcessedGenreList(movies: movies)
        XCTAssertEqual(genreList, ["Comedy", "Romance"])
    }
    
    func testProcessedActorsList() {
        let actorsList = utility.getProcessedActorsList(movies: movies)
        XCTAssertEqual(actorsList, ["Robert De Niro", "Ben Stiller", "Teri Polo", "Blythe Danner", "Adel Emam", "Sherine", "Osama Abbas", "Rushdi El Mahdi"].sorted())
    }
    
    func testProcessedDirectorsList() {
        let directorsList = utility.getProcessedDirectorsList(movies: movies)
        XCTAssertEqual(directorsList, ["Jay Roach", "Nader Galal", "Kamlah Abu-Zikri"].sorted())
    }
}
