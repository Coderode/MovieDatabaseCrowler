//
//  MovieDetailVC.swift
//  MovieDatabase
//
//  Created by Sandeep kushwaha on 13/07/24.
//

import Foundation
import UIKit
import Kingfisher

class MovieDetailVC: UIViewController {
    var posterImageView: UIImageView!
    var titleLabel: UILabel!
    var plotLabel: UILabel!
    var crewLabel: UILabel!
    var releaseDateLabel: UILabel!
    var castLabel: UILabel!
    var genreLabel: UILabel!
    var ratingControl: RatingControl!
    var ratingTitleLabel: UILabel!
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var movie: Movie?
    
    class func instantiate(movie: Movie) -> UIViewController {
        let vc = MovieDetailVC()
        vc.movie = movie
        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.configure()
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(false, animated: false)
        navigationController?.navigationBar.barTintColor = .lightGray
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "Movie Detail"
        self.navigationItem.setHidesBackButton(false, animated: false)
        navigationController?.navigationBar.barTintColor = .lightGray
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.addBottomLine()
    }
    
    func getRatingSources() -> [String] {
        guard let movie = movie else { return [] }
        return (movie.ratings?.map({$0.source ?? ""}) ?? []).filter({!$0.isEmpty})
    }
    
    private func configure() {
        guard let movie = movie else { return }
        if let imageUrl = URL(string: movie.poster ?? "") {
            posterImageView.kf.setImage(
                with: imageUrl,
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
        } else {
            posterImageView.image = UIImage(named: "placeHolderImage")
        }
        ratingTitleLabel.text = "Rating:"
        titleLabel.text = movie.title ?? ""
        plotLabel.text = movie.plot ?? ""
        crewLabel.attributedText = getAttributedText(key: "Crew: ", text: "\(movie.director ?? "") \(movie.writer ?? "")")
        castLabel.attributedText = getAttributedText(key: "Cast: ", text: "\(movie.actors ?? "")")
        releaseDateLabel.attributedText = getAttributedText(key: "Released: ", text: "\(movie.released ?? "")")
        genreLabel.attributedText = getAttributedText(key: "Genre: ", text: "\(movie.genre ?? "")")
        
        var ratingsDict = [String: String]()
        movie.ratings?.forEach { rating in
            ratingsDict[rating.source ?? ""] = rating.value ?? ""
        }
        ratingControl.ratingValues = ratingsDict
    }
    
    private func getAttributedText(key: String, text: String) -> NSMutableAttributedString {
        // Create a mutable attributed string
        let attributedString = NSMutableAttributedString(string: key)

        // Define attributes for the "Crew:" part (bold and black)
        let boldFont = UIFont.boldSystemFont(ofSize: 17)  // Adjust font size as needed
        let attributes: [NSAttributedString.Key: Any] = [
            .font: boldFont,
            .foregroundColor: UIColor.black
        ]

        // Apply attributes to the key part
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: key.count))  // Length of key

        // Append director and writer if they exist
        attributedString.append(NSAttributedString(string: text, attributes: [.foregroundColor: UIColor.black]))
        return attributedString
    }
}

