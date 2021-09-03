//
//  SearchResultResponse.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/3/21.
//

import Foundation



struct SearchResultResponse: Codable {
    let albums: SearchAlbumResponse
    let artists: SearchArtistResponse
    let playlists: SearchPlaylistsResponse
    let tracks: SearchTracksResponse
}

struct SearchAlbumResponse: Codable {
    let items: [Album]
}

struct SearchArtistResponse: Codable {
    let items: [Artist]
}

struct SearchPlaylistsResponse: Codable {
    let items: [Playlist]
}

struct SearchTracksResponse: Codable {
    let items: [AudioTrack]
}

//struct SearchEpisodesResponse: Codable {
//    let items: [Album]
//}

//struct SearchShowsResponse: Codable {
//    let items: [Album]
//}

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
