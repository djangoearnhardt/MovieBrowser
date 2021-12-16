//
//  MovieJSON.swift
//  MovieBrowser
//
//  Created by Sam LoBue on 12/8/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

struct MovieJSON: Decodable {
    let page: Int?
    let results: [Movie]?
    let total_pages: Int?
    let total_results: Int?
}

struct Movie: Decodable {
    let original_title: String
    let overview: String?
    let release_date: String?
    let poster_path: String?
    let vote_average: Double
}
