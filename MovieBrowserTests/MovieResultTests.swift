//
//  MovieResultTests.swift
//  MovieBrowserTests
//
//  Created by Sam LoBue on 12/17/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

@testable import MovieBrowser
import XCTest

class MovieResultTests: XCTestCase {
    func testMovieJSONDecodesSuccessfully() throws {
        let movies = try XCTUnwrap(moviesFromMovieJSONData(), "Movies should decode from JSON")
        if let starWars = movies.first(where: { $0.original_title == "Star Wars" }) {
            XCTAssertEqual(starWars.release_date, "1977-05-25")
            XCTAssertEqual(starWars.poster_path, "/6FfCtAuVAW8XJjZ7eWeLibRLWTw.jpg")
            XCTAssertEqual(starWars.vote_average, 8.2)
            XCTAssertEqual(starWars.overview, "Princess Leia is captured and held hostage by the evil Imperial forces in their effort to take over the galactic Empire. Venturesome Luke Skywalker and dashing captain Han Solo team together with the loveable robot duo R2-D2 and C-3PO to rescue the beautiful princess and restore peace and justice in the Empire.")
        }
        if let legoStarWars = movies.first(where: { $0.original_title == "LEGO Star Wars Terrifying Tales" }) {
            XCTAssertEqual(legoStarWars.release_date, "2021-10-01")
            XCTAssertEqual(legoStarWars.poster_path, "/fYiaBZDjyXjvlY6EDZMAxIhBO1I.jpg")
            XCTAssertEqual(legoStarWars.vote_average, 6.8)
            XCTAssertEqual(legoStarWars.overview, "Poe Dameron and BB-8 must face the greedy crime boss Graballa the Hutt, who has purchased Darth Vader’s castle and is renovating it into the galaxy’s first all-inclusive Sith-inspired luxury hotel.")
        }
    }
}

extension MovieResultTests {
    private func movieJSONData() -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: "MovieJSON", ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    private func moviesFromMovieJSONData() throws -> [Movie]? {
        guard let data = movieJSONData() else {
            return []
        }
        let decoder = JSONDecoder()
        let movieJSON = try decoder.decode(MovieJSON.self, from: data)
        return movieJSON.results
    }
}
