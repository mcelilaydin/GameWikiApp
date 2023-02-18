//
//  GameDetails.swift
//  GameWikiApp
//
//  Created by Celil Aydın on 6.02.2023.
//

import Foundation

struct GameDetails: Decodable {
    let id: Int
    let name: String
    let descriptionRaw: String
    let released: String
    let platforms: [PlatformElement]
    
    enum CodingKeys: String, CodingKey {
        case id, name, released, platforms
        case descriptionRaw = "description_raw"
    }
}

struct PlatformElement: Decodable {
    let platform: PlatformPlatform
}

struct PlatformPlatform: Decodable {
    let id: Int
    let name, slug: String
}
