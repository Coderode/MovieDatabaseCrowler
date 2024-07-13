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
    var movieModelUtility: MovieModelUtilityProtocol
    var searchKey : String = ""
    private var apiService: NetworkService
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
                self.processMoviesLocalData(movies: data)
            } catch let error {
                self.apiError.value = error
            }
        }
    }
    
    private func processMoviesLocalData(movies: Movies) {
        let genres = self.movieModelUtility.getProcessedGenreList(movies: movies)
        let year = self.movieModelUtility.getProcessedYearsList(movies: movies)
        let actors = self.movieModelUtility.getProcessedActorsList(movies: movies)
        let directors = self.movieModelUtility.getProcessedDirectorsList(movies: movies)
        let datasourceArray : [MovieDatasource] = [
            MovieDatasource(item: .year(values: year)),
            MovieDatasource(item: .genre(values: genres)),
            MovieDatasource(item: .directors(values: directors)),
            MovieDatasource(item: .actors(values: actors)),
            MovieDatasource(item: .allMovies(values: movies))
        ]
        datasource.value = datasourceArray
    }
    
    func fetchSearchedKeyMovies(searchKey: String, movies: Movies) -> Movies {
        return self.movieModelUtility.searchMovies(with: searchKey, in: movies)
    }

}

struct MovieDatasource {
    var item: MovieDatasourceEnum
    var isExpanded: Bool = false
}

enum MovieDatasourceEnum {
    case genre(values: [String])
    case year(values: [String])
    case directors(values: [String])
    case actors(values: [String])
    case allMovies(values: Movies)
    
    var title: String {
        switch self {
        case .genre(values: _):
            return "Genre"
        case .year(values: _):
            return "Year"
        case .directors(values: _):
            return "Directors"
        case .actors(values: _):
            return "Actors"
        case .allMovies(values: _):
            return "All Movies"
        }
    }
    var count: Int {
        switch self {
        case .genre(values: let values), .year(values: let values), .directors(values: let values), .actors(values: let values) :
            return values.count
        case .allMovies(values: let values):
            return values.count
        }
    }
}
