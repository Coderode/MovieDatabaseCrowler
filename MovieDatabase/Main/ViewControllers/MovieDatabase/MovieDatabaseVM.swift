//
//  MovieDatabaseVM.swift
//  MovieDatabase
//
//  Created by Sandeep kushwaha on 13/07/24.
//

import Foundation

class MovieDatabaseVM {
    var movies : Movies = []
    var datasource: ObservableCollection<[MovieDatasource]> = ObservableCollection([])
    var apiError: Observable<Error?> = Observable(nil)
    var isSearchEnabled: Observable<Bool> = Observable(false)
    private var movieModelUtility: MovieModelUtilityProtocol
    private var apiService: NetworkService
    var searchKey : String = ""
    
    init(apiService: NetworkService, movieModelUtility: MovieModelUtilityProtocol) {
        self.apiService = apiService
        self.movieModelUtility = movieModelUtility
    }
    
    func fetchData() {
        Task { [weak self] in
            guard let self else { return }
            do {
                var data : Movies = try await self.apiService.fetchData(with: nil)
                if !searchKey.isEmpty {
                    data = self.fetchSearchedKeyMovies(searchKey: searchKey, movies: data)
                }
                self.movies = data
                self.datasource.value = self.processMoviesFilterData(movies: data)
            } catch let error {
                self.apiError.value = error
            }
        }
    }
    
    private func processMoviesFilterData(movies: Movies) -> [MovieDatasource] {
        let genres = self.movieModelUtility.getProcessedGenreList(movies: movies)
        let year = self.movieModelUtility.getProcessedYearsList(movies: movies)
        let actors = self.movieModelUtility.getProcessedActorsList(movies: movies)
        let directors = self.movieModelUtility.getProcessedDirectorsList(movies: movies)
        let datasourceArray : [MovieDatasource] = [
            MovieDatasource(filter: .year, items: year),
            MovieDatasource(filter: .genre, items: genres),
            MovieDatasource(filter: .directors, items: directors),
            MovieDatasource(filter: .actors, items: actors),
            MovieDatasource(filter: .allMovies, items: [])
        ]
        return datasourceArray
    }
    
    func fetchSearchedKeyMovies(searchKey: String, movies: Movies) -> Movies {
        return self.movieModelUtility.searchMovies(with: searchKey, in: movies)
    }
    
    func filterData(filterValue: String, filterType: MovieDataFilter) -> Movies {
        return movies.filtered(using: self.movieModelUtility.getMovieFilter(with: filterValue, and: filterType))
    }
}

struct MovieDatasource {
    var filter: MovieDataFilter
    var items: [String] = []
    var isExpanded: Bool = false
}
