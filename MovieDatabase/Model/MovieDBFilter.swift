//
//  MovieDBFilterUtility.swift
//  MovieDatabase
//
//  Created by Sandeep kushwaha on 27/07/24.
//

import Foundation

protocol Filter {
    var value: String { set get }
    func isSatisfied<Item>(by item: Item) -> Bool
}

extension Array {
    func filtered(using filter: Filter) -> [Element] {
        return self.filter { filter.isSatisfied(by: $0) }
    }
}

struct GenreFilter: Filter {
    var value: String = ""
    func isSatisfied<Item>(by item: Item) -> Bool {
        guard let movie = item as? Movie else { return false }
        return movie.genre?.lowercased().contains(value.lowercased()) ?? false
    }
}

struct YearFilter: Filter {
    var value: String = ""
    func isSatisfied<Item>(by item: Item) -> Bool {
        guard let movie = item as? Movie else { return false }
        return movie.year?.lowercased().contains(value.lowercased()) ?? false
    }
}

struct ActorFilter: Filter {
    var value: String = ""
    func isSatisfied<Item>(by item: Item) -> Bool {
        guard let movie = item as? Movie else { return false }
        return movie.actors?.lowercased().contains(value.lowercased()) ?? false
    }
}

struct DirectorFilter: Filter {
    var value: String = ""
    func isSatisfied<Item>(by item: Item) -> Bool {
        guard let movie = item as? Movie else { return false }
        return movie.director?.lowercased().contains(value.lowercased()) ?? false
    }
}

struct AllMoviesFilter: Filter {
    var value: String = ""
    func isSatisfied<Item>(by item: Item) -> Bool {
        return true
    }
}

enum MovieDataFilter: Comparable {
    case genre
    case year
    case directors
    case actors
    case allMovies
    
    var title: String {
        switch self {
        case .genre:
            return "Genre"
        case .year:
            return "Year"
        case .directors:
            return "Directors"
        case .actors:
            return "Actors"
        case .allMovies:
            return "All Movies"
        }
    }
    
    static func < (lhs: MovieDataFilter, rhs: MovieDataFilter) -> Bool {
        lhs.title == rhs.title
    }
}
