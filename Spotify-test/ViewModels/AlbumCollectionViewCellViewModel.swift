//
//  AlbumCollectionViewCellViewModel.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/3/21.
//

import Foundation

struct AlbumCollectionViewCellViewModel {
    let name: String
    let artworkURL: URL?
    let artistName: String
    let track_number: Int?
    
    let external_urls: [String: String]?
//    let total: Int?
}
