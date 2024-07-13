//
//  RatingControl.swift
//  MovieDatabase
//
//  Created by Sandeep kushwaha on 13/07/24.
//

import Foundation
import UIKit

class RatingControl: UIControl {
    private var ratingValueLabel: UILabel!
    private var ratingSourceSegmentedControl: UISegmentedControl!
    
    var ratingSources: [String] = []
    var ratingValues: [String: String] = [:] {
        didSet {
            updateRatingValue()
        }
    }
    
    init(ratingSources: [String]) {
        self.ratingSources = ratingSources
        super.init(frame: .zero)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        ratingValueLabel = UILabel()
        ratingValueLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingValueLabel.font = UIFont.systemFont(ofSize: 16)
        ratingValueLabel.textColor = .black
        addSubview(ratingValueLabel)
        
        ratingSourceSegmentedControl = UISegmentedControl(items: ratingSources)
        ratingSourceSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        ratingSourceSegmentedControl.selectedSegmentIndex = 0
        ratingSourceSegmentedControl.addTarget(self, action: #selector(ratingSourceChanged), for: .valueChanged)
        addSubview(ratingSourceSegmentedControl)
        
        NSLayoutConstraint.activate([
            ratingSourceSegmentedControl.topAnchor.constraint(equalTo: topAnchor),
            ratingSourceSegmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingSourceSegmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            ratingValueLabel.topAnchor.constraint(equalTo: ratingSourceSegmentedControl.bottomAnchor, constant: 8),
            ratingValueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            ratingValueLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        updateRatingValue()
    }
    
    @objc private func ratingSourceChanged() {
        updateRatingValue()
    }
    
    private func updateRatingValue() {
        let selectedSource = ratingSources[ratingSourceSegmentedControl.selectedSegmentIndex]
        ratingValueLabel.text = ratingValues[selectedSource] ?? "N/A"
    }
}
