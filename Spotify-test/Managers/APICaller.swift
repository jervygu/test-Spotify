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
                    //let json = try JSONSerialization.jsonObject(with: safeData, options: .allowFragments)
                    let result = try JSONDecoder().decode(UserProfile.self, from: safeData)
//                    print(result)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    /// Get All New Releases
    public func getNewReleases(completion: @escaping(Result<NewReleasesResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?country=PH&limit=15"), with: .GET) { (request) in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let safeData = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: safeData)
                    //print(result)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    /// Get All Featured Playlists
    public func getFeaturedPlaylists(completion: @escaping(Result<FeaturedPlaylistsReponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?country=PH&limit=20"), with: .GET) { (request) in
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let safeData = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistsReponse.self, from: safeData)
                    //print(result)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    /// Get Recommendation Genres
    public func getRecommendationGenres(completion: @escaping(Result<RecommendationGenresResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"), with: .GET) { (request) in
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let safeData = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendationGenresResponse.self, from: safeData)
                    //print(result)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    /// Get Recommendations
    public func getRecommendations(genres: Set<String>, completion: @escaping(Result<RecommendationsResponse, Error>) -> Void) {
        let seeds = genres.joined(separator: ",")
        
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations?seed_genres=\(seeds)&limit=10&country=PH"), with: .GET) { (request) in
            // print("Recommended genre: ", request.url?.absoluteURL)
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let safeData = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    //let result = try JSONSerialization.jsonObject(with: safeData, options: .allowFragments)
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: safeData)
//                    print(result)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    /// Get Current User's Recently Played Tracks
    public func getRecentPlayedTracks(completion: @escaping(Result<RecentlyPlayedTracksResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/me/player/recently-played?limit=15"), with: .GET) { (request) in
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let safeData = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
//                    let result = try JSONSerialization.jsonObject(with: safeData, options: .allowFragments)
                    let result = try JSONDecoder().decode(RecentlyPlayedTracksResponse.self, from: safeData)
//                    print(result)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCurrentUserAlbums(completion: @escaping (Result<[Album], Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/me/albums"), with: .GET) { (request) in
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
//                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(CurrentUserAlbumsResponse.self, from: data)
//                    print(result)
                    completion(.success(result.items.compactMap({ $0.album })))
                } catch {
//                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    public func getCategories(completion: @escaping(Result<[Category], Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories?limit=50&country=PH"), with: .GET) { (request) in
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    //                    let result = try JSONSerializatio n.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    print(result.categories.items)
                    completion(.success(result.categories.items))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCategoryPlaylists(withCategory category: Category, completion: @escaping(Result<[Playlist], Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories/\(category.id)/playlists?country=PH&limit=50"), with: .GET) { (request) in
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    //                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(CategorysPlaylistsResponse.self, from: data)
                    let playlists = result.playlists.items
                    print(playlists)
                    completion(.success(playlists))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func saveAlbum(album: Album, completion: @escaping(Bool) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/me/albums?ids=\(album.id)"), with: .PUT) { (baseRequest) in
            var request = baseRequest
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let code = (response as? HTTPURLResponse)?.statusCode,
                      error == nil else {
                    completion(false)
                    return
                }
                print(code)
                completion(code == 200)
            }
            task.resume()
        }
    }
    
    public func getAlbumDetails(forAlbum album: Album, completion: @escaping(Result<AlbumDetailsResponse, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/albums/" + album.id),
            with: .GET) { (request) in
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
//                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
//                    print(result)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getPlaylistDetails(withPlaylist playlist: Playlist, completion: @escaping(Result<PlaylistDetailsResponse, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/playlists/" + playlist.id),
            with: .GET) { (request) in
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
//                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
//                    print(result)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCurrentUserPlaylists(completion: @escaping(Result<[Playlist], Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/me/playlists/?limit=50"), with: .GET) { (request) in
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
//                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(CurrentUserPlaylistsResponse.self, from: data)
//                    print(result)
                    completion(.success(result.items))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func createPlaylist(withName name: String, completion: @escaping(Bool) -> Void) {
        getCurrentUserProfile { [weak self] (result) in
            switch result {
            case .success(let profile):
                let urlString = Constants.baseAPIURL + "/users/\(profile.id)/playlists"
                
                self?.createRequest(with: URL(string: urlString), with: .POST) { (baseRequest) in
                    var request = baseRequest
                    let json = [
                        "name": name
                    ]
                    
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                    
                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        guard let data = data, error == nil else {
                            completion(false)
                            return
                        }
                        do {
                            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                            let result = try JSONDecoder().decode(Playlist.self, from: data)
                            if let response = result as? [String: Any], response["id"] as? String != nil {
                                print("Created!")
                                print(result)
                                completion(true)
                            } else {
                                print("Failed to get ID")
                                completion(false)
                            }
                            completion(true)
                            
                        } catch {
                            print(error.localizedDescription)
                            completion(false)
                        }
                    }
                    task.resume()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func addTrackToPlaylist(track: AudioTrack, playlist: Playlist, completion: @escaping(Bool) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/\(playlist.id)/tracks"), with: .POST) {
            baseRequest in
            var request = baseRequest
            let json = [
                "uris": [
                    "spotify:track:\(track.id)"
                ]
            ]
            
            print(json)
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    
                    if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                    
                } catch {
                    completion(false)
                }
            }
            task.resume()
        }
    }
    
    public func removeTrackFromPlaylist(track: AudioTrack, playlist: Playlist, completion: @escaping(Bool) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/\(playlist.id)/tracks"), with: .DELETE) {
            baseRequest in
            var request = baseRequest
            let json: [String: Any] = [
                "tracks": [
                    [
                        "uri": "spotify:track:\(track.id)"
                    ]
                ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    
                    print(result)
                    
                    if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                    
                } catch {
                    completion(false)
                }
            }
            task.resume()
        }
    }
    
    
    public func getCurrentUserFollowing(completion: @escaping(Result<UserFollowingArtistsResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/me/following?type=artist&limit=20"),
                      with: .GET
        ){ (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, response, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(UserFollowingArtistsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    print("UserFollowingResponse: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    public func search(withQuery query: String, completion: @escaping(Result<[SearchResult], Error>) -> Void) {
        createRequest(
            with: URL(
                string: Constants.baseAPIURL + "/search?limit=10&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"), with: .GET) { (request) in
            
            print(request.url?.absoluteString ?? "none")
            
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    //                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                    var searchResults: [SearchResult] = []
                    
                    searchResults.append(contentsOf: result.tracks.items.compactMap({ SearchResult.track(model: $0) }))
                    searchResults.append(contentsOf: result.albums.items.compactMap({ SearchResult.album(model: $0 )}))
                    searchResults.append(contentsOf: result.artists.items.compactMap({ SearchResult.artist(model: $0 )}))
                    searchResults.append(contentsOf: result.playlists.items.compactMap({ SearchResult.playlist(model: $0) }))
                    
                    print("searchResults: \(searchResults)")
                    completion(.success(searchResults))
                } catch {
                    print(error)
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
    
    // escaping completion block when we have to use closures inside our methods, and its going to be asynchronous
    /// URLRequest with Authorization header
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


