//
//  AuthManager.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 8/31/21.
//

import Foundation

/// Managers - are objects in the app that allows us to perform operations across the whole app
final class AuthManager {
    static let shared = AuthManager()
    
    struct Constants {
        static let clientID = "43db0c8fac104023a77aace978575ab9"
        static let clientSecret = "95a021ef785741b4a87995628e2e18e2"
    }
    
    private init() {}
    
    public var signInURL: URL? {
        let baseURL = "https://accounts.spotify.com/authorize"
        let scopes = "user-read-private"
        let redirectURI = "https://jervygu.wixsite.com/iosdev"
        let stringURL = "\(baseURL)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=true"
        
        return URL(string: stringURL)
    }
    
    
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
    
    public func exchangeCodeforToken(code: String, completion: @escaping((Bool) -> Void)) {
        // get Token
    }
    
    public func refreshAccessToken() {
        
    }
    
    public func cacheToken() {
        
    }
    
    
}


//Client ID         43db0c8fac104023a77aace978575ab9
//Client Secret     95a021ef785741b4a87995628e2e18e2
//Redirect URI      https://jervygu.wixsite.com/iosdev
//                  https://jervygu.github.io/
