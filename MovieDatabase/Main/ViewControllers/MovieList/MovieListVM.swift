//
//  MovieListVM.swift
//  MovieDatabase
//
//  Created by Sandeep kushwaha on 26/07/24.
//

import Foundation


protocol MovieListVMDelegate: AnyObject {
    func dataSorted()
}

class MovieListVM {
    var movies: Movies = []
    weak var delegate: MovieListVMDelegate?
    init(movies: Movies, delegate: MovieListVMDelegate) {
        self.movies = movies
        self.delegate = delegate
    }
    
    func sortMoviesData(with option: Sort) {
        self.movies = self.movies.sorted(using: option)
        self.delegate?.dataSorted()
    }
}
