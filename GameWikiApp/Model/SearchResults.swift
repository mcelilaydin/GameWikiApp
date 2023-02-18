//
//  SearchResults.swift
//  GameWikiApp
//
//  Created by Celil Aydın on 5.02.2023.
//

import Foundation

struct SearchResults: Decodable {
    
    let count: Int
    let next: String
    let results: [SearchData]
    let userPlatforms: Bool?
    
    enum CodingKeys: String, CodingKey {
        case count, next, results
        case userPlatforms = "user_platforms"
    }
    
}

// MARK: - Result
struct SearchData: Decodable {
    
    let slug, name: String
    let backgroundImage: String
    let id: Int
    let shortScreenshots: [ShortScreenshot]
    
    enum CodingKeys: String, CodingKey {
        case slug, name
        case backgroundImage = "background_image"
        case id
        case shortScreenshots = "short_screenshots"
    }
}

struct ShortScreenshot: Decodable {
    let id: Int
    let image: String
}
