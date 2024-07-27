//
//  MovieListVC.swift
//  MovieDatabase
//
//  Created by Sandeep kushwaha on 13/07/24.
//

import Foundation
import UIKit

class MovieListVC: UIViewController {
    var viewModel: MovieListVM!
    var tableView : UITableView!
    var refreshControl: UIRefreshControl!
    var sortOptions: [Sort] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layoutViewComponents()
        self.setupNavigationBar()
    }
    
    class func instantiate(movies: Movies, sortOptions: [Sort]) -> UIViewController {
        let vc = MovieListVC()
        vc.sortOptions = sortOptions
        vc.viewModel = MovieListVM(movies: movies, delegate: vc)
        return vc
    }
    
    lazy var sortButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        button.setTitle("", for: .normal)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(false, animated: false)
        navigationController?.navigationBar.barTintColor = .lightGray
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "Movie List"
        let sortButtonItem = UIBarButtonItem(customView: sortButton)
        self.navigationItem.rightBarButtonItems = [sortButtonItem]
        self.navigationItem.setHidesBackButton(false, animated: false)
        navigationController?.navigationBar.barTintColor = .lightGray
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.addBottomLine()
        sortButton.addTarget(self, action: #selector(didTapSortButton), for: .touchUpInside)
    }
    
    @objc func didTapSortButton() {
        let sortView = SortView.instantiate(data: self.sortOptions, delegate: self, popoverView: self.sortButton)
        self.present(sortView, animated: true)
    }
    
    @objc func refreshData() {
        self.view.removeLoader()
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()
    }
}

extension MovieListVC : SortListVCDelegate {
    func didSelectSortOption(option: Sort) {
        self.viewModel.sortMoviesData(with: option)
    }
}

extension MovieListVC : MovieListVMDelegate {
    func dataSorted() {
        self.tableView.reloadData()
    }
}
