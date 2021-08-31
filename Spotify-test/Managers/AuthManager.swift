//
//  AuthManager.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 8/31/21.
//

import Foundation

/// Managers - are objects in the app the allows us to perform operations across the whole app
final class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    var isSignedIn: Bool {
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
    
    
    
    
}
