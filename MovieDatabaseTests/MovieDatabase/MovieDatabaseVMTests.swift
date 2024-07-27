//
//  MovieDatabaseVMTests.swift
//  MovieDatabaseTests
//
//  Created by Sandeep kushwaha on 27/07/24.
//

import XCTest
@testable import MovieDatabase

final class MovieDatabaseVMTests: XCTestCase {
    var viewModel: MovieDatabaseVM!
    var mockAPIService: NetworkService!
    var modelUtility: MovieModelUtilityProtocol!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockMovieDataService()
        modelUtility = MovieModelUtility()
        viewModel = MovieDatabaseVM(apiService: mockAPIService, movieModelUtility: modelUtility)
        let expectation = XCTestExpectation(description: "Fetch movies")
        viewModel.fetchData()
        viewModel.datasource.bind { _ in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    override func tearDown() {
        super.tearDown()
        self.modelUtility = nil
        self.mockAPIService = nil
        self.viewModel = nil
    }
    func testInitialization() {
        XCTAssertNotNil(viewModel)
    }
    
    func testDataFetch() {
        XCTAssertEqual(viewModel.movies.count, 2)
        XCTAssertNil(viewModel.apiError.value)
        XCTAssertEqual(viewModel.datasource.value.count, 5)
    }
    
    func testFilterMoviesByYear() {
        let filteredMovies = viewModel.filterData(filterValue: "2000", filterType: .year)
        XCTAssertEqual(filteredMovies.count, 2) // according to the mock test data
        XCTAssertTrue(filteredMovies.allSatisfy { $0.year?.contains("2000") ?? false })
    }
    
    func testFilterMoviesByGenre() {
        let filteredMovies = viewModel.filterData(filterValue: "Romance", filterType: .genre)
        XCTAssertEqual(filteredMovies.count, 1)
        XCTAssertTrue(filteredMovies.allSatisfy { $0.genre?.contains("Romance") ?? false  })
    }
    
    func testFilterMoviesByActor() {
        let filteredMovies = viewModel.filterData(filterValue: "Robert De Niro", filterType: .actors)
        XCTAssertEqual(filteredMovies.count, 1)
        XCTAssertTrue(filteredMovies.allSatisfy { $0.actors?.contains("Robert De Niro") ?? false  })
    }
    
    func testFilterMoviesByDirector() {
        let filteredMovies = viewModel.filterData(filterValue: "Jay Roach", filterType: .directors)
        XCTAssertEqual(filteredMovies.count, 1)
        XCTAssertTrue(filteredMovies.allSatisfy { $0.director?.contains("Jay Roach") ?? false  })
    }
    
    func testSearchMoviesByTitle() {
        let searchKey = "Meet the Parents"
        let searchResults = viewModel.fetchSearchedKeyMovies(searchKey: searchKey, movies: viewModel.movies)
        XCTAssertEqual(searchResults.count, 1)
        XCTAssertEqual(searchResults.first?.title, searchKey)
    }

    func testSearchMoviesByGenre() {
        let searchKey = "Comedy"
        let searchResults = viewModel.fetchSearchedKeyMovies(searchKey: searchKey, movies: viewModel.movies)
        XCTAssertEqual(searchResults.count, 2)
        XCTAssertTrue(searchResults.first?.genre?.contains(searchKey) ?? false)
    }
}
