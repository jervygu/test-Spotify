//
//  PlaylistHeaderViewViewModel.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/3/21.
//

import Foundation

struct PlaylistHeaderViewViewModel: Codable {
    let name: String?
    let ownerName: String?
    let description: String?
    let artworkURL: URL?
    let total: Int?
}
