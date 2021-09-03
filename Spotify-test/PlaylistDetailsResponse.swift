//
//  PlaylistDetailsResponse.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/3/21.
//

import Foundation

struct PlaylistDetailsResponse: Codable {
    let description: String
    let external_urls: [String: String]
    let followers: Follower?
    let href: String
    let id: String
    let images: [APIImage]
    let name: String
    let owner: Owner
    let primary_color: String?
    let tracks: Tracks
}

struct Tracks: Codable {
    let items: [PlaylistItem]
    let total: Int
}

struct PlaylistItem: Codable {
    let track: AudioTrack
}
