//
//  UserFollowingArtistsResponse.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/3/21.
//

import Foundation

struct UserFollowingArtistsResponse: Codable {
    var artists: FollowingArtist
}

struct FollowingArtist: Codable {
    let items: [Artist]
    var total: Int
}
