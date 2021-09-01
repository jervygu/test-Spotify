//
//  AuthManager.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 8/31/21.
//


import Foundation

// https://developer.spotify.com/documentation/general/guides/authorization-guide/
//1. Obtain authorization with scope
//    Refreshable user authorization: Authorization Code Flow
//    Refreshable user authorization: Authorization Code Flow With Proof Key for Code Exchange (PKCE)
//    Temporary user authorization: Implicit Grant
//    Refreshable app authorization: Client Credentials Flow
// https://developer.spotify.com/assets/AuthG_AuthoriztionCode.png
//2. Have your application request authorization; the user logs in and authorizes access
//3. Have your application request refresh and access tokens; Spotify returns access and refresh tokens
//4. Use the access token to access the Spotify Web API; Spotify returns requested data
//5. Requesting a refreshed access token; Spotify returns a new access token to your app
//6.

// 1. get code to exchange for token
// 2. exchange code for token to grant


/// Managers - are objects in the app that allows us to perform operations across the whole app
final class AuthManager {
    static let shared = AuthManager()
    
    private var refreshingToken = false
    
    struct Constants {
        static let clientID = "43db0c8fac104023a77aace978575ab9"
        static let clientSecret = "95a021ef785741b4a87995628e2e18e2"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://jervygu.wixsite.com/iosdev"
        static let baseURL = "https://accounts.spotify.com/authorize"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    private init() {}
    
    public var signInURL: URL? {
        let stringURL = "\(Constants.baseURL)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=true"
        
        return URL(string: stringURL)
    }
    
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expiration_date") as? Date
    }
    
    /// Should refresh token before the expiration time
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        // add five mins interval to refresh token to make sure its always valid
        let fiveMins: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMins) >= expirationDate
    }
    
    /// Have your application request refresh and access tokens; Spotify returns access and refresh tokens
    public func exchangeCodeforToken(code: String, completion: @escaping((Bool) -> Void)) {
        // get Token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        var components = URLComponents()
        // REQUEST BODY PARAMETER
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // HEADER PARAMETER,    POST request must contain this as defined in the OAuth 2.0
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = components.query?.data(using: .utf8)
        
        // HEADER PARAMETER for Authorization
        // Basic *<base64 encoded client_id:client_secret>*
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        // convert to data
        let tokenData = basicToken.data(using: .utf8)
        // base64 encoded
        guard let base64TokenString = tokenData?.base64EncodedString() else {
            print("Failed to get base64 Token")
            completion(false)
            return
        }
        
        let tokenValue = "Basic " + base64TokenString
        request.setValue(tokenValue, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            guard let safeData = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                // 1. Json serialization and then make a model/struct from the json response
//                let json = try JSONSerialization.jsonObject(with: safeData, options: .allowFragments)
                // 2. Json decoder and use the model/struct created from json serialization
                let result = try JSONDecoder().decode(AuthResponse.self, from: safeData)
                self?.cacheToken(result: result)
//                print("SUCCESS get Token: - \(result)")
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            } 
            
            
        }
        task.resume()
        
    }
    
    private var onRefreshBlocks = [((String) -> Void)]()
    
    /// Supplies with valid token to be used with APICalls
    public func withValidToken(completion: @escaping(String) -> Void) {
        guard !refreshingToken else {
            // append the completion to be executed once the refreshingToken has completed
            // allows refreshToken once
            onRefreshBlocks.append(completion)
            return
        }
        
        if shouldRefreshToken {
            // refresh token
            refreshAccessTokenIfNeeded { [weak self] needed in
                if needed {
                    if let token = self?.accessToken, needed {
                        completion(token)
                    }
                }
            }
        } else if let token = accessToken {
            completion(token)
        }
    }
    
    /// Requesting a refreshed access token; Spotify returns a new access token to your app
    public func refreshAccessTokenIfNeeded(completion: @escaping(Bool) -> Void) {
        guard !refreshingToken else {
            return
        }
        
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        // Refresh the Token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        refreshingToken = true
        
        var components = URLComponents()
        // REQUEST BODY PARAMETER
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = components.query?.data(using: .utf8)
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let tokenData = basicToken.data(using: .utf8)
        guard let base64TokenString = tokenData?.base64EncodedString() else {
            print("Failed to get base64 Token")
            completion(false)
            return
        }
        
        let tokenValue = "Basic " + base64TokenString
        request.setValue(tokenValue, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            self?.refreshingToken = false
            guard let safeData = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: safeData)
                // to pass back the access_token
                self?.onRefreshBlocks.forEach({ $0(result.access_token) })
                // remove all to not redundantly call one of the blocks that we've saved
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                print("SUCCESS Refresh Token: - \(result)")
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    /// Save Token to UserDefaults
    public func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(result.token_type, forKey: "token_type")
        UserDefaults.standard.setValue(result.scope, forKey: "scope")
        // current time + 3600 secs to cache expiration date time
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expiration_date")
    }
    
    
}
