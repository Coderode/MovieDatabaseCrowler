//
//  MovieListVC.swift
//  MovieDatabase
//
//  Created by Sandeep kushwaha on 13/07/24.
//

import Foundation
import UIKit

class MovieListVC: UIViewController {
    var movieList : Movies = []
    var tableView : UITableView!
    var refreshControl: UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layoutViewComponents()
        self.setupNavigationBar()
    }
    
    class func instantiate(movies: Movies) -> UIViewController {
        let vc = MovieListVC()
        vc.movieList = movies
        return vc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(false, animated: false)
        navigationController?.navigationBar.barTintColor = .lightGray
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "Movie List"
        self.navigationItem.setHidesBackButton(false, animated: false)
        navigationController?.navigationBar.barTintColor = .lightGray
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.addBottomLine()
    }
    
    @objc func refreshData() {
        self.view.removeLoader()
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()
    }
    
}
