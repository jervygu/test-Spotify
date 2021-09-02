//
//  AudioTrack.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 8/31/21.
//

import Foundation

struct AudioTrack: Codable {
    var album: Album?
    let artists: [Artist]
    let available_markets: [String]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_urls: [String: String]
    let href: String
    let id: String
    let name: String
    let popularity: Int?
    let track_number: Int
    let type: String
    
    let preview_url: String?
}
