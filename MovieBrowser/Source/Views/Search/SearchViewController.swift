//
//  SearchViewController.swift
//  SampleApp
//
//  Created by Struzinski, Mark on 2/19/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - ViewModel
    private var searchResultViewModels: [SearchResultViewModel] = [] {
        didSet {
            DispatchQueue.main.async {
                if self.searchResultViewModels.isEmpty {
                    self.presentNoResultsAlert()
                }
                self.tableView?.reloadData()
            }
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar?
    @IBOutlet weak var goButton: UIButton?
    @IBOutlet weak var tableView: UITableView?
    
    // MARK: - Properties
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    private let movieReuseID = "movieCell"
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Actions
    @IBAction func goButtonTapped(_ sender: Any) {
        guard let searchBar = searchBar, let searchText = searchBar.text, !searchText.isEmpty else {
            presentNoSearchTextAlert()
            return
        }
        self.view.endEditing(true)
        searchMovie(by: searchText) { error in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            if let error = error {
                self.presentErrorAlert(error: error)
            }
        }
    }
    
    // MARK: - Helper Functions
    func setUp() {
        view.backgroundColor = .white
        setUpNavBar()
        setUpSearchBar()
        setUpTableView()
        setUpActivityIndicator()
    }
    
    func setUpNavBar() {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = UIColor(named: "navBarBlue")
            self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
    func setUpSearchBar() {
        guard let searchBar = searchBar else {
            return
        }
        searchBar.delegate = self
    }
    
    func setUpTableView() {
        guard let tableView = tableView else {
            return
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: movieReuseID)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
    }
    
    func setUpActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func searchMovie(by title: String, completion: @escaping (Error?) -> Void) {
        // Start activityIndicator
        activityIndicator.startAnimating()
        FetchingController.shared.fetchMovieBy(search: title) { result in
            switch result {
            case .failure(let error):
                completion(error)
            case .success(let movies):
                let viewModels = movies.compactMap { SearchResultViewModel(movie: $0) }
                self.searchResultViewModels = viewModels
                completion(nil)
            }
        }
    }
    
    func presentNoResultsAlert() {
        print("OOPS: Need a valid API key from https://www.themoviedb.org")
        let alertController = UIAlertController(
            title: "Uh oh",
            message: "No movies found for that title. Try another search.",
            preferredStyle: .alert)
        let soundsGoodAction = UIAlertAction(
            title: "Ok",
            style: .default)
        alertController.addAction(soundsGoodAction)
        present(alertController, animated: true)
    }
    
    func presentNoSearchTextAlert() {
        let alertController = UIAlertController(
            title: "Oops",
            message: "Please enter a valid search, with more than one character.",
            preferredStyle: .alert)
        let soundsGoodAction = UIAlertAction(
            title: "Ok",
            style: .default)
        alertController.addAction(soundsGoodAction)
        present(alertController, animated: true)
    }
    
    func presentErrorAlert(error: Error) {
        let alertController = UIAlertController(
            title: "Error fetching movie",
            message: "\(error.localizedDescription)",
            preferredStyle: .alert)
        let soundsGoodAction = UIAlertAction(
            title: "Ok",
            style: .default)
        alertController.addAction(soundsGoodAction)
        present(alertController, animated: true)
    }
}

// MARK: - TableView Delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResultViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: movieReuseID, for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        cell.searchResultViewModel = searchResultViewModels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResultViewModel = searchResultViewModels[indexPath.row]
        let nextVC = MovieDetailViewController(searchResultViewModel: searchResultViewModel)
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - UISearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            presentNoSearchTextAlert()
            return
        }
        searchBar.resignFirstResponder()
        searchMovie(by: searchText) { error in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            if let error = error {
                self.presentErrorAlert(error: error)
            }
        }
    }
}
