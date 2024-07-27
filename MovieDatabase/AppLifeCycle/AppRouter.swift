//
//  AppRouter.swift
//  MovieDatabase
//
//  Created by Sandeep kushwaha on 13/07/24.
//

import Foundation
import UIKit

enum AppRoute {
    case movieList(movies: Movies)
    case movieDatabase
    case movieDetail(movie: Movie)
}

class AppRouter {
    
    static let shared = AppRouter()
    private init() {}
    var navigationController: UINavigationController?
    
    func navigate(to route: AppRoute) {
        let viewController = createViewController(for: route)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func createViewController(for route: AppRoute) -> UIViewController {
        switch route {
        case .movieList(let movies):
            return createMoviewListVC(movies: movies)
        case .movieDatabase:
            return createMoviewDatabaseVC()
        case .movieDetail(movie: let movie):
            return createMovieDetailVC(movie: movie)
        }
    }
    
    private func createMoviewListVC(movies: Movies) -> UIViewController {
        let sortOptions : [Sort] = [TitleAscendingSort(), TitleDescendingSort(), YearSort()]
        return MovieListVC.instantiate(movies: movies, sortOptions: sortOptions)
    }
    
    private func createMoviewDatabaseVC() -> UIViewController {
        let localNetworkService = LocalMovieDataService()
        return MovieDatabaseVC.instantiate(apiService: localNetworkService, movieModelUtility: MovieModelUtility())
    }
    
    private func createMovieDetailVC(movie: Movie) -> UIViewController {
        return MovieDetailVC.instantiate(movie: movie)
    }
}
