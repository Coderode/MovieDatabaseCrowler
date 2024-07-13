//
//  MovieDetailVC+Extension.swift
//  MovieDatabase
//
//  Created by Sandeep kushwaha on 13/07/24.
//

import Foundation
import UIKit

extension MovieDetailVC {
    func setupUI() {
        view.backgroundColor = .white
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        posterImageView = UIImageView()
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(posterImageView)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        plotLabel = UILabel()
        plotLabel.translatesAutoresizingMaskIntoConstraints = false
        plotLabel.font = UIFont.systemFont(ofSize: 16)
        plotLabel.numberOfLines = 0
        contentView.addSubview(plotLabel)
        
        crewLabel = UILabel()
        crewLabel.translatesAutoresizingMaskIntoConstraints = false
        crewLabel.font = UIFont.systemFont(ofSize: 16)
        crewLabel.numberOfLines = 0
        contentView.addSubview(crewLabel)
        
        castLabel = UILabel()
        castLabel.translatesAutoresizingMaskIntoConstraints = false
        castLabel.font = UIFont.systemFont(ofSize: 16)
        castLabel.numberOfLines = 0
        contentView.addSubview(castLabel)
        
        
        ratingTitleLabel = UILabel()
        ratingTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        contentView.addSubview(ratingTitleLabel)
        
        releaseDateLabel = UILabel()
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        releaseDateLabel.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(releaseDateLabel)
        
        genreLabel = UILabel()
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(genreLabel)
        
        ratingControl = RatingControl(ratingSources: self.getRatingSources())
        ratingControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ratingControl)
        
        
        // Set constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.30),
            posterImageView.heightAnchor.constraint(equalToConstant: 180),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            plotLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            plotLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            plotLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            crewLabel.topAnchor.constraint(equalTo: plotLabel.bottomAnchor, constant: 8),
            crewLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            crewLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            castLabel.topAnchor.constraint(equalTo: crewLabel.bottomAnchor, constant: 8),
            castLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            castLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            releaseDateLabel.topAnchor.constraint(equalTo: castLabel.bottomAnchor, constant: 8),
            releaseDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            releaseDateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            genreLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 8),
            genreLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genreLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            ratingTitleLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 8),
            ratingTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ratingTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            ratingControl.topAnchor.constraint(equalTo: ratingTitleLabel.bottomAnchor, constant: 16),
            ratingControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ratingControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ratingControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
