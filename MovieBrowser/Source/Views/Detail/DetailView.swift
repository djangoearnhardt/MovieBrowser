//
//  DetailView.swift
//  MovieBrowser
//
//  Created by Sam LoBue on 12/9/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

class DetailView: UIView {
    
    // MARK: - View model
    var searchResultViewModel: SearchResultViewModel? {
        didSet {
            updateLabels {
                self.updatePoster()
            }
        }
    }
    
    // MARK: - Properties
    enum Layout {
        static let posterTopMargin: CGFloat = 20
        static let posterHeight: CGFloat = 230
        static let smallMargin: CGFloat = 10
    }
    
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1), size: 21)
        label.textAlignment = .center
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13.0)
        label.textColor = .lightGray
        return label
    }()
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let summaryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - Lifecycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        constructSubviews()
        constructSubviewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constructSubviews() {
        addSubview(titleLabel)
        addSubview(releaseDateLabel)
        addSubview(posterImageView)
        addSubview(summaryLabel)
    }
    
    func constructSubviewConstraints() {
        let views = [titleLabel, releaseDateLabel, posterImageView, summaryLabel]
        
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        // titleLabel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Layout.smallMargin),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // releaseDateLabel
        NSLayoutConstraint.activate([
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Layout.smallMargin),
            releaseDateLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        // posterImageView
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: Layout.posterTopMargin),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.smallMargin),
            posterImageView.widthAnchor.constraint(equalToConstant: screenWidth * 0.5),
            posterImageView.heightAnchor.constraint(equalToConstant: Layout.posterHeight)
        ])
        
        // summaryLabel
        NSLayoutConstraint.activate([
            summaryLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            summaryLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: Layout.smallMargin),
            summaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(Layout.smallMargin * 2)),
        ])
    }
    
    // MARK: - Helper Functions
    func updateLabels(completion: @escaping () -> Void) {
        titleLabel.text = searchResultViewModel?.title
        if let releaseDate = searchResultViewModel?.releaseDate {
            releaseDateLabel.text = "Release Date: \(String(describing: DateHelper.shared.monthDayYearWithSlashesFrom(releaseDate)))"
        }
        summaryLabel.text = searchResultViewModel?.summary
        completion()
    }
    
    func updatePoster() {
        if let imageData = imageDataFrom(posterPath: searchResultViewModel?.posterPath) {
            // To simulate a slow connection, change `delay`'s value to 1.0 or greater
            // This displays the placeholder image, until the poster data has loaded
            let delay = 0.0
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.posterImageView.image = UIImage(data: imageData)
                self.posterImageView.reloadInputViews()
            }
        }
    }
    
    func imageDataFrom(posterPath: String?) -> Data? {
        if let posterPath = posterPath,
           let posterURL = URL(string: Network.posterPathURL + posterPath) {
            do {
                let imageData = try Data(contentsOf: posterURL)
                return imageData
            } catch {
                print("Error decoding poster: \(error)")
                return nil
            }
        } else {
            return nil
        }
    }
}
