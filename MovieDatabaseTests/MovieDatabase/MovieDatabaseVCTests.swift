//
//  MovieDatabaseVCTests.swift
//  MovieDatabaseTests
//
//  Created by Sandeep kushwaha on 27/07/24.
//

import XCTest
import UIKit
@testable import MovieDatabase


final class MovieDatabaseVCTests: XCTestCase {
    func makeSUT() -> MovieDatabaseVC? {
        let apiService = MockMovieDataService()
        let modelUtility = MovieModelUtility()
        let vc = MovieDatabaseVC.instantiate(apiService: apiService, movieModelUtility: modelUtility) as? MovieDatabaseVC
        return vc
    }

    func testInitialization() {
        let databaseVC = makeSUT()
        XCTAssertNotNil(databaseVC)
    }
    
    func testViewDidLoad() {
        let databaseVC = makeSUT()
        databaseVC?.loadViewIfNeeded()
        XCTAssertTrue(databaseVC?.isViewLoaded ?? false)
    }
    
    func testMovieDataLoaded() {
        let databaseVC = makeSUT()
        databaseVC?.loadViewIfNeeded()
        databaseVC?.viewDidLoad()
        XCTAssertEqual(databaseVC?.viewModel.movies.count, 2)
    }
}
