//
//  MovieUtility.swift
//  MovieDatabase
//
//  Created by Sandeep kushwaha on 13/07/24.
//

import Foundation

protocol MovieModelUtilityProtocol {
    func getProcessedGenreList(movies: Movies) -> [String]
    func getProcessedYearsList(movies: Movies) -> [String]
    func getProcessedActorsList(movies: Movies) -> [String]
    func getProcessedDirectorsList(movies: Movies) -> [String]
    func filterMovies(with value: String, and key: MovieDatasourceEnum, in movies: Movies) -> Movies
    func searchMovies(with value: String, in movies: Movies) -> Movies
}

struct MovieModelUtility : MovieModelUtilityProtocol {
    
    func filterMovies(with value: String, and key: MovieDatasourceEnum, in movies: Movies) -> Movies {
        switch key {
        case .genre:
            return movies.filter({ $0.genre?.contains(value) ?? false })
        case .year:
            return movies.filter({ $0.year?.contains(value) ?? false })
        case .actors:
            return movies.filter({ $0.actors?.contains(value) ?? false })
        case .directors:
            return movies.filter({ $0.director?.contains(value) ?? false })
        default:
            return movies
        }
    }
    
    func getProcessedGenreList(movies: Movies) -> [String] {
        let genresArray: [String] = movies.map({$0.genre ?? ""}).filter({!$0.isEmpty})
        var allGenresSet: Set<String> = []
        for genres in genresArray {
            let individualGenres = genres.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            allGenresSet.formUnion(individualGenres)
        }
        return Array(allGenresSet).sorted()
    }
    
    func getProcessedYearsList(movies: Movies) -> [String] {
        let year: [String] = movies.map({$0.year ?? ""}).filter({!$0.isEmpty})
        var resultantYears: [String] = []
        for item in year {
            let components = item.split(separator: "–").map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
            for component in components {
                if !component.isEmpty {
                    resultantYears.append(String(component))
                }
            }
        }
        return Array(Set(resultantYears)).sorted()
    }
    
    func getProcessedActorsList(movies: Movies) -> [String] {
        let actorsArray: [String] = movies.map({$0.actors ?? ""}).filter({!$0.isEmpty})
        var actorsSet: Set<String> = []
        for actors in actorsArray {
            if actors == "N/A" { continue }
            let individualActors = actors.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            actorsSet.formUnion(individualActors)
        }
        return Array(actorsSet).sorted()
    }
    
    func getProcessedDirectorsList(movies: Movies) -> [String] {
        let directorsArray = movies.map({$0.director ?? ""}).filter({!$0.isEmpty})
        var directorsSet: Set<String> = []
        for directors in directorsArray {
            if directors == "N/A" { continue }
            let individualDirectors = directors.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            for director in individualDirectors {
                let cleanDirector = director.replacingOccurrences(of: "(co-director)", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                directorsSet.insert(cleanDirector)
            }
        }
        return Array(directorsSet).sorted()
    }
    
    func searchMovies(with value: String, in movies: Movies) -> Movies {
        return movies.filter { movie in
            return movie.title?.contains(value) ?? false || movie.genre?.contains(value) ?? false || movie.actors?.contains(value) ?? false || movie.director?.contains(value) ?? false
         }
    }
}
