//
//  MovieDatabaseVC+Extension.swift
//  MovieDatabase
//
//  Created by Sandeep kushwaha on 13/07/24.
//


import Foundation
import UIKit

extension MovieDatabaseVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.isSearchEnabled.value ? 1 : self.viewModel.datasource.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.isSearchEnabled.value {
            return self.viewModel.movies.count
        } else {
            return self.viewModel.datasource.value[section].isExpanded ? self.viewModel.datasource.value[section].item.count : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !self.viewModel.isSearchEnabled.value else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(MovieListTableViewCell.self)", for: indexPath) as! MovieListTableViewCell
            cell.configure(with: self.viewModel.movies[indexPath.row])
            return cell
        }
        let data = self.viewModel.datasource.value[indexPath.section]
        switch data.item {
        case .genre(values: let values), .year(values: let values), .directors(values: let values), .actors(values: let values):
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(MovieFilterTableViewCell.self)", for: indexPath) as! MovieFilterTableViewCell
            cell.configure(with: values[indexPath.row])
            return cell
        case .allMovies(values: let values):
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(MovieListTableViewCell.self)", for: indexPath) as! MovieListTableViewCell
            cell.configure(with: values[indexPath.row])
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !self.viewModel.isSearchEnabled.value else {
            return nil
        }
        let data = self.viewModel.datasource.value[section]
        let headerView = SectionHeaderView(title: data.item.title, section: section, isExpanded: data.isExpanded)
        headerView.delegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard !self.viewModel.isSearchEnabled.value else {
            return 0
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !self.viewModel.isSearchEnabled.value else {
            let movieData = self.viewModel.movies[indexPath.row]
            // show detail page
            AppRouter.shared.navigate(to: .movieDetail(movie: movieData))
            return
        }
        let data = self.viewModel.datasource.value[indexPath.section]
        switch data.item {
        case .genre(values: let values), .year(values: let values), .directors(values: let values), .actors(values: let values):
            let filterValue = values[indexPath.row]
            AppRouter.shared.navigate(to: .movieList(movies: self.viewModel.movieModelUtility.filterMovies(with: filterValue, and: data.item, in: self.viewModel.movies)))
        case .allMovies(values: let values):
            let movieData = values[indexPath.row]
            // show detail page
            AppRouter.shared.navigate(to: .movieDetail(movie: movieData))
        }
    }
}

extension MovieDatabaseVC {
    func layoutViewComponents() {
        tableView = UITableView(frame: .zero)
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        searchHeaderView = SearchHeaderVeiw(frame: .zero)
        searchHeaderView.delegate = self
        self.view.addSubview(searchHeaderView)
        searchHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            searchHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchHeaderView.heightAnchor.constraint(equalToConstant: 40),
            tableView.topAnchor.constraint(equalTo: searchHeaderView.bottomAnchor, constant: 5),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.register(MovieFilterTableViewCell.self, forCellReuseIdentifier: "\(MovieFilterTableViewCell.self)")
        tableView.register(MovieListTableViewCell.self, forCellReuseIdentifier: "\(MovieListTableViewCell.self)")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.lightGray
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
}

extension MovieDatabaseVC : SectionHeaderViewDelegate {
    func didTapHeaderView(section: Int) {
        self.viewModel.datasource.value[section].isExpanded.toggle()
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}

extension MovieDatabaseVC : SearchHeaderVeiwDelegate {
    
    func didChangeSearchField(text: String) {
        DispatchQueue.main.asyncDeduped(target: self, after: 1.0) {
            self.viewModel.searchKey = text
            self.view.showLoader(.black)
            self.viewModel.fetchData()
        }
        DispatchQueue.main.async {
            self.viewModel.isSearchEnabled.value = !text.isEmpty
        }
    }
    func didTapSearchField() {
        // action on tap
        self.viewModel.isSearchEnabled.value = true
    }
}
