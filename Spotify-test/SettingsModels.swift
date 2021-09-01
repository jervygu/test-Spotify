//
//  SettingsModels.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/1/21.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
