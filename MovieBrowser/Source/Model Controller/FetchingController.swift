//
//  FetchingController.swift
//  MovieBrowser
//
//  Created by Sam LoBue on 12/8/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation

class FetchingController {
    static let shared = FetchingController()
    private let urlSession = URLSession.shared
    private let apiKey = Network.apiKey
    
    func fetchMovieBy(search: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let urlRequest = buildURLRequestFor(search: search) else {
            completion(.failure(URLError.invalidURLRequest))
            return
        }
        let dataTask = urlSession.dataTask(with: urlRequest) { (data, _, error) in
            if let data = data {
                do {
                    let movieJSON = try JSONDecoder().decode(MovieJSON.self, from: data)
                    let movies = movieJSON.results?.sorted { $0.original_title < $1.original_title }
                    completion(.success(movies ?? []))
                } catch {
                    completion(.failure(error))
                }
            }
            
            if let error = error {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    func fetchPosterDataBy(_ posterPath: String?, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let posterPath = posterPath, let url = URL(string: Network.posterPathURL + posterPath) else {
            completion(.failure(URLError.invalidPosterPath))
            return
        }
        let dataTask = urlSession.dataTask(with: url) { (data, _, error) in
            if let data = data {
                completion(.success(data))
            }
            
            if let error = error {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    private func buildURLRequestFor(search: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = "/3/search/movie/"
        let movie = URLQueryItem(name: "query", value: search)
        let apiKey = URLQueryItem(name: "api_key", value: apiKey)
        urlComponents.queryItems = [apiKey, movie]
        guard let fullURL = urlComponents.url else {
            return nil
        }
        let urlRequest = URLRequest(url: fullURL)
        return urlRequest
    }
}
