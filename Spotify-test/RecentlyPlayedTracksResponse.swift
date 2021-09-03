//
//  RecentlyPlayedTracksResponse.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/2/21.
//

import Foundation

struct RecentlyPlayedTracksResponse: Codable {
    let items: [RecentTracks]
    let next: String
    let cursors: [String: String]
    let limit: Int
    let href: String
}

struct RecentTracks: Codable {
    let track: AudioTrack
}
