//
//  MovieDatabaseVC.swift
//  MovieDatabase
//
//  Created by Sandeep kushwaha on 13/07/24.
//

import Foundation
import UIKit

class MovieDatabaseVC: UIViewController {
    var viewModel: MovieDatabaseVM!
    
    var tableView : UITableView!
    var searchHeaderView: SearchHeaderVeiw!
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.layoutViewComponents()
        self.bindData()
        self.viewModel.fetchData()
        self.view.showLoader(.black)
    }
    class func instantiate(apiService: NetworkService, movieModelUtility: MovieModelUtilityProtocol) -> UIViewController {
        let vc = MovieDatabaseVC()
        vc.viewModel = MovieDatabaseVM(apiService: apiService, movieModelUtility: movieModelUtility)
        return vc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.barTintColor = .lightGray
        navigationController?.navigationBar.tintColor = .lightGray
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "Movie Database"
        self.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.barTintColor = .lightGray
        navigationController?.navigationBar.tintColor = .lightGray
        navigationController?.navigationBar.addBottomLine()
    }
    
    func bindData() {
        self.viewModel.datasource.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.view.removeLoader()
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            }
        }
        
        self.viewModel.apiError.bind { [weak self] error in
            DispatchQueue.main.async {
                Toast.showErrorMessage(error: error ?? NetworkError.SomethingWentWrong)
                self?.refreshControl.endRefreshing()
                self?.view.removeLoader()
            }
        }
        
        self.viewModel.isSearchEnabled.bind { [weak self] isEnabled in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc func refreshData() {
        self.viewModel.fetchData()
    }
}

