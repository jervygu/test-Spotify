//
//  CurrentUserPlaylistsResponse.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/3/21.
//

import Foundation

struct CurrentUserPlaylistsResponse: Codable {
    let items: [Playlist]
}
