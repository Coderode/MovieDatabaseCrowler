//
//  MovieListVMTests.swift
//  MovieDatabaseTests
//
//  Created by Sandeep kushwaha on 27/07/24.
//

import XCTest
@testable import MovieDatabase

final class MovieListVMTests: XCTestCase {
    var viewModel: MovieListVM!
    var movies: Movies!
    var delegate: MovieListMockDelegate!
    
    override func setUp() {
        super.setUp()
        delegate = MovieListMockDelegate()
        
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
        viewModel = MovieListVM(movies: movies, delegate: delegate)
    }
    
    override func tearDown() {
        super.tearDown()
        self.delegate = nil
        self.movies = nil
        self.viewModel = nil
    }
    func testInitialization() {
        XCTAssertNotNil(viewModel)
        XCTAssertFalse(delegate.isMovieListSorted)
    }
    
    func testDataFetch() {
        XCTAssertEqual(viewModel.movies.count, 2)
        XCTAssertFalse(delegate.isMovieListSorted)
    }
    
    func testSortMoviesByYear() {
        viewModel.sortMoviesData(with: YearSort())
        XCTAssertEqual(viewModel.movies.first?.title, "Hello America")
        XCTAssertEqual(viewModel.movies.last?.title, "Meet the Parents")
        XCTAssertTrue(delegate.isMovieListSorted)
    }
    
    func testSortMoviesByAscendingTitle() {
        viewModel.sortMoviesData(with: TitleAscendingSort())
        XCTAssertEqual(viewModel.movies.first?.title, "Hello America")
        XCTAssertEqual(viewModel.movies.last?.title, "Meet the Parents")
        XCTAssertTrue(delegate.isMovieListSorted)
    }
    
    func testSortMoviesByDescendingTitle() {
        viewModel.sortMoviesData(with: TitleDescendingSort())
        XCTAssertEqual(viewModel.movies.first?.title, "Meet the Parents")
        XCTAssertEqual(viewModel.movies.last?.title, "Hello America")
        XCTAssertTrue(delegate.isMovieListSorted)
    }

}

class MovieListMockDelegate: MovieListVMDelegate {
    var isMovieListSorted: Bool = false
    func dataSorted() {
        isMovieListSorted = true
    }
}
