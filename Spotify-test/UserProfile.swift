//
//  UserProfile.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 8/31/21.
//

import Foundation

struct UserProfile: Codable {
    let country: String
    let display_name: String
    let email: String
    let explicit_content: [String: Bool]
    let external_urls: [String: String]
    
    let followers: Follower?
    
    let id: String
    let product: String
    let images: [APIImage]
    
//    var following: UserFollowingArtistsResponse?
}

struct Follower: Codable {
    let href: String? 
    let total: Int?
}

struct APIImage: Codable {
    let url: String
}
