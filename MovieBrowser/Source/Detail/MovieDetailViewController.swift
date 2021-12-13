//
//  MovieDetailViewController.swift
//  SampleApp
//
//  Created by Struzinski, Mark on 2/26/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let detailView: DetailView = DetailView()
    
    enum Layout {
        static let verticalMargin: CGFloat = 20
    }
    
    // MARK: - Lifecycle
    init(searchResultViewModel: SearchResultViewModel) {
        super.init(nibName: nil, bundle: nil)
        detailView.searchResultViewModel = searchResultViewModel
        self.setUpViewController()
        self.constructSubviews()
        self.constructSubviewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    func setUpViewController() {
        view.backgroundColor = .white
    }
    
    func constructSubviews() {
        view.addSubview(detailView)
    }
    
    func constructSubviewConstraints() {
        detailView.translatesAutoresizingMaskIntoConstraints = false
        
        // detailView
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.verticalMargin),
            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
