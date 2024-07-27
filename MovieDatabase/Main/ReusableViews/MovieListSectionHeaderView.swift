//
//  MovieListSectionHeaderView.swift
//  MovieDatabase
//
//  Created by Sandeep kushwaha on 13/07/24.
//

import Foundation
import UIKit

protocol SectionHeaderViewDelegate : AnyObject {
    func didTapHeaderView(section: Int)
}

class SectionHeaderView: UIView {
    
    var section: Int
    var shouldToggle: Bool = false
    weak var delegate: SectionHeaderViewDelegate?
    var isExpanded: Bool = false {
        didSet {
            updateArrowImage(isExpanded: isExpanded)
        }
    }
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(title: String, section: Int, isExpanded: Bool, shouldToggle : Bool = true) {
        self.section = section
        super.init(frame: .zero)
        self.isExpanded = isExpanded
        self.shouldToggle = shouldToggle
        self.backgroundColor = .lightGray
        titleLabel.text = title
        self.addSubview(titleLabel)
        self.addSubview(separatorLine)
        self.addSubview(arrowImageView)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: separatorLine.topAnchor, constant: -10),
            
            arrowImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20),
            
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            separatorLine.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.tag = section
        self.updateArrowImage(isExpanded: isExpanded)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.addGestureRecognizer(tapGesture)
    }
    @objc func didTap() {
        if shouldToggle {
            self.isExpanded.toggle()
        }
        self.delegate?.didTapHeaderView(section: self.section)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateArrowImage(isExpanded: Bool) {
        if shouldToggle {
            let arrowImage = isExpanded ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
            arrowImageView.image = arrowImage
        } else {
            arrowImageView.image = UIImage(systemName: "chevron.right")
        }
    }
}
