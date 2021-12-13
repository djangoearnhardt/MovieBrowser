//
//  SearchResultViewModel.swift
//  MovieBrowser
//
//  Created by Sam LoBue on 12/8/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation

struct SearchResultViewModel {
    let title: String
    let summary: String
    let releaseDate: String?
    let posterPath: String?
    let rating: String
    
    init(movie: Movie) {
        self.title = movie.original_title
        self.summary = movie.overview
        self.releaseDate = movie.release_date
        self.rating = String(movie.vote_average)
        self.posterPath = movie.poster_path
    }
}
