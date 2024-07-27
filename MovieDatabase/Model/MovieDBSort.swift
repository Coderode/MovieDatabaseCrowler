//
//  MovieDBSortUtility.swift
//  MovieDatabase
//
//  Created by Sandeep kushwaha on 27/07/24.
//

import Foundation

protocol Sort {
    var title: String { get }
    func compare<Item>(_ lhs: Item, _ rhs: Item) -> Bool
}

extension Array {
    func sorted(using sort: Sort) -> [Element] {
        return self.sorted { sort.compare($0, $1) }
    }
}

struct TitleAscendingSort: Sort {
    var title: String = "Ascending"
    
    func compare<Item>(_ lhs: Item, _ rhs: Item) -> Bool {
        guard let lhsMovie = lhs as? Movie, let rhsMovie = rhs as? Movie else { return false }
        return lhsMovie.title ?? "" < rhsMovie.title ?? ""
    }
}

struct TitleDescendingSort: Sort {
    var title: String = "Descending"
    func compare<Item>(_ lhs: Item, _ rhs: Item) -> Bool {
        guard let lhsMovie = lhs as? Movie, let rhsMovie = rhs as? Movie else { return false }
        return lhsMovie.title ?? "" > rhsMovie.title ?? ""
    }
}

struct YearSort: Sort {
    var title: String = "Year"
    func compare<Item>(_ lhs: Item, _ rhs: Item) -> Bool {
        guard let lhsMovie = lhs as? Movie, let rhsMovie = rhs as? Movie else { return false }
        return lhsMovie.year ?? "" <= rhsMovie.year ?? "" && lhsMovie.title ?? "" < rhsMovie.title ?? ""
    }
}
