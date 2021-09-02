//
//  NewReleasesResponse.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/2/21.
//

import Foundation

struct NewReleasesResponse: Codable {
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
    let items: [Album]
}

struct FeaturedPlaylistsReponse: Codable {
    let playlists: PlaylistsResponse
}

struct CategorysPlaylistsResponse: Codable {
    let playlists: PlaylistsResponse
}


struct PlaylistsResponse: Codable {
    let items: [Playlist]
}

struct Track: Codable {
    let href: String
    let total: Int
}

struct Owner: Codable {
    let display_name: String
    let external_urls: [String: String]
    let href: String
    let id: String
    let type: String
}
