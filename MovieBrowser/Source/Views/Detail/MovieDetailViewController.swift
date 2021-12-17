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
    private let scrollView: UIScrollView = UIScrollView()
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
        view.addSubview(scrollView)
        scrollView.addSubview(detailView)
    }
    
    func constructSubviewConstraints() {
        let views = [scrollView, detailView]
        
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        // scrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.verticalMargin),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // detailView
        NSLayoutConstraint.activate([
            detailView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            detailView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            detailView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}
