//
//  Artist.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 8/31/21.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
    
    let images: [APIImage]?
}
