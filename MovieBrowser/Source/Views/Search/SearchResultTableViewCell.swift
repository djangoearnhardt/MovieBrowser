//
//  SearchResultTableViewCell.swift
//  MovieBrowser
//
//  Created by Sam LoBue on 12/8/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    // MARK: - View model
    var searchResultViewModel: SearchResultViewModel? {
        didSet {
            updateLabels()
        }
    }
    
    // MARK: - Properties
    enum Layout {
        static let topMargin: CGFloat = 20
        static let verticalMargin: CGFloat = 20
        static let titleVerticalMargin: CGFloat = 95
        static let smallMargin: CGFloat = 10
        static let separatorHeight: CGFloat = 1
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .headline), size: 20)
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constructSubviews()
        constructSubviewConstraints()
        accessoryType = .disclosureIndicator
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    func constructSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(separatorView)
    }
    
    func constructSubviewConstraints() {
        let views = [titleLabel, releaseDateLabel, ratingLabel, separatorView]
        
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        // titleLabel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.topMargin),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.verticalMargin),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.titleVerticalMargin)
        ])
        
        // releaseDateLabel
        NSLayoutConstraint.activate([
            releaseDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Layout.topMargin),
            releaseDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.smallMargin),
        ])
        
        // ratingLabel
        NSLayoutConstraint.activate([
            ratingLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.smallMargin)
        ])
        
        // separatorView
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: Layout.separatorHeight),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func updateLabels() {
        titleLabel.text = searchResultViewModel?.title
        if let releaseDate = searchResultViewModel?.releaseDate {
            releaseDateLabel.text = DateHelper.shared.monthDayYearFrom(releaseDate)
        }
        ratingLabel.text = searchResultViewModel?.rating
    }
}
