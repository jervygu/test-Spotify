//
//  CurrentUserAlbumsResponse.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/3/21.
//

import Foundation

struct CurrentUserAlbumsResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let added_at: String
    let album: Album
}
