//
//  DateHelper.swift
//  MovieBrowser
//
//  Created by Sam LoBue on 12/9/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation

class DateHelper {
    
    static let shared = DateHelper()
    
    private init () {}
    
    let dateFormatter = DateFormatter()
    
    func monthDayYearFrom(_ dateString: String) -> String {
        dateFormatter.dateFormat = "yyyy-mm-dd"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "MMMM d, yyyy"
        if let date = date {
            let formattedString = dateFormatter.string(from: date)
            return formattedString
        } else {
            return dateString
        }
    }
    
    func monthDayYearWithSlashesFrom(_ dateString: String) -> String {
        dateFormatter.dateFormat = "yyyy-mm-dd"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "M/d/yy"
        if let date = date {
            let formattedString = dateFormatter.string(from: date)
            return formattedString
        } else {
            return dateString
        }
    }
}
