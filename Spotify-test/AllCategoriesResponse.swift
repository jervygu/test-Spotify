//
//  AllCategoriesResponse.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/3/21.
//

import Foundation

struct AllCategoriesResponse: Codable {
    let categories: Categories
}

struct Categories: Codable {
    let items: [Category]
    let total: Int
}

struct Category: Codable {
    let href: String
    let id: String
    let name: String
    let icons: [APIImage]
}
