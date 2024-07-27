//
//  MovieListTableViewCell.swift
//  MovieDatabase
//
//  Created by Sandeep kushwaha on 13/07/24.
//

import Foundation
import UIKit
import Kingfisher

class MovieListTableViewCell: UITableViewCell {

    var imageUrl: URL?
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, languageLabel, yearLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(infoStackView)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 80),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 100),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            infoStackView.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
            infoStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        languageLabel.font = .systemFont(ofSize: 16, weight: .regular)
        yearLabel.font = .systemFont(ofSize: 14, weight: .regular)
        titleLabel.numberOfLines = 2
        languageLabel.numberOfLines = 0
        titleLabel.textColor = .black
        languageLabel.textColor = .black
        yearLabel.textColor = .black
        self.clipsToBounds = true
        self.selectionStyle = .default
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
        self.languageLabel.text = ""
        self.yearLabel.text = ""
        self.thumbnailImageView.image = nil
        self.imageUrl = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with movie: Movie) {
        self.imageUrl = URL(string: movie.poster ?? "")
        titleLabel.text = movie.title ?? ""
        languageLabel.text = "Language: \(movie.language ?? "")"
        yearLabel.text = "Year: \(movie.year ?? "")"
        thumbnailImageView.kf.setImage(
            with: self.imageUrl,
            placeholder: UIImage(named: "placeHolderImage"),
            options: [
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.25)),
            ],
            progressBlock: { receivedSize, totalSize in
                // Progress updated
            },
            completionHandler: { result in
                // Done
            }
        )
    }
}
