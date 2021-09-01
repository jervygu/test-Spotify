//
//  APICaller.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 8/31/21.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    private init() {}
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    /// Get Current User Profile
    public func getCurrentUserProfile(completion: @escaping(Result<UserProfile, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/me"), with: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, _, error) in
                guard let safeData = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
//                    let result = try JSONSerialization.jsonObject(with: safeData, options: .allowFragments)
                    let result = try JSONDecoder().decode(UserProfile.self, from: safeData)
                    print(result)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    
    
    

}

// MARK: - Private

extension APICaller {
    
    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    /// URLRequest with Authorization header
    // escaping completion block when we have to use closures inside our methods, and its going to be asynchronous
    private func createRequest(with url: URL?, with type: HTTPMethod, completion: @escaping(URLRequest) -> Void) {
        AuthManager.shared.withValidToken(completion: { token in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            // set value for Authorization header
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
            
        })
    }
}
