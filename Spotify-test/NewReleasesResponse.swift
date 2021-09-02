//
//  NewReleasesResponse.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/2/21.
//

import Foundation

struct NewReleasesResponse: Codable {
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
    let items: [Album]
}

struct FeaturedPlaylistsReponse: Codable {
    let playlists: PlaylistsResponse
}

struct CategorysPlaylistsResponse: Codable {
    let playlists: PlaylistsResponse
}


struct PlaylistsResponse: Codable {
    let items: [Playlist]
}

struct Track: Codable {
    let href: String
    let total: Int
}

struct Owner: Codable {
    let display_name: String
    let external_urls: [String: String]
    let href: String
    let id: String
    let type: String
}

//{
//    message = "Lie down and close your eyes";
//    playlists =     {
//        href = "https://api.spotify.com/v1/browse/featured-playlists?country=PH&timestamp=2021-09-02T02%3A59%3A22&offset=0&limit=3";
//        items =         (
//                        {
//                collaborative = 0;
//                description = "Steady rain without any thunder.";
//                "external_urls" =                 {
//                    spotify = "https://open.spotify.com/playlist/37i9dQZF1DX8ymr6UES7vc";
//                };
//                href = "https://api.spotify.com/v1/playlists/37i9dQZF1DX8ymr6UES7vc";
//                id = 37i9dQZF1DX8ymr6UES7vc;
//                images =                 (
//                                        {
//                        height = "<null>";
//                        url = "https://i.scdn.co/image/ab67706f00000003aba1f07094bd3e98cd0122de";
//                        width = "<null>";
//                    }
//                );
//                name = "Rain Sounds";
//                owner =                 {
//                    "display_name" = Spotify;
//                    "external_urls" =                     {
//                        spotify = "https://open.spotify.com/user/spotify";
//                    };
//                    href = "https://api.spotify.com/v1/users/spotify";
//                    id = spotify;
//                    type = user;
//                    uri = "spotify:user:spotify";
//                };
//                "primary_color" = "<null>";
//                public = "<null>";
//                "snapshot_id" = MTYyOTM4MTMwNiwwMDAwMDA0MzAwMDAwMTdiNWViMWE2ZGYwMDAwMDE3M2I4ZGU5Yjgx;
//                tracks =                 {
//                    href = "https://api.spotify.com/v1/playlists/37i9dQZF1DX8ymr6UES7vc/tracks";
//                    total = 170;
//                };
//                type = playlist;
//                uri = "spotify:playlist:37i9dQZF1DX8ymr6UES7vc";
//            },
//                        {
//                collaborative = 0;
//                description = "Let these jazz tracks lull you to sleep.";
//                "external_urls" =                 {
//                    spotify = "https://open.spotify.com/playlist/37i9dQZF1DXa1rZf8gLhyz";
//                };
//                href = "https://api.spotify.com/v1/playlists/37i9dQZF1DXa1rZf8gLhyz";
//                id = 37i9dQZF1DXa1rZf8gLhyz;
//                images =                 (
//                                        {
//                        height = "<null>";
//                        url = "https://i.scdn.co/image/ab67706f0000000308e683238978c7d578b96046";
//                        width = "<null>";
//                    }
//                );
//                name = "Jazz for Sleep";
//                owner =                 {
//                    "display_name" = Spotify;
//                    "external_urls" =                     {
//                        spotify = "https://open.spotify.com/user/spotify";
//                    };
//                    href = "https://api.spotify.com/v1/users/spotify";
//                    id = spotify;
//                    type = user;
//                    uri = "spotify:user:spotify";
//                };
//                "primary_color" = "<null>";
//                public = "<null>";
//                "snapshot_id" = MTYzMDQxNDI3OSwwMDAwMDA3NjAwMDAwMTdiOWM0Mzk1MmYwMDAwMDE2ZDAwYjRhZjc4;
//                tracks =                 {
//                    href = "https://api.spotify.com/v1/playlists/37i9dQZF1DXa1rZf8gLhyz/tracks";
//                    total = 102;
//                };
//                type = playlist;
//                uri = "spotify:playlist:37i9dQZF1DXa1rZf8gLhyz";
//            },
//                        {
//                collaborative = 0;
//                description = "Kick back to the soothing sounds of the Ukulele...";
//                "external_urls" =                 {
//                    spotify = "https://open.spotify.com/playlist/37i9dQZF1DX5FuBDzVtEFX";
//                };
//                href = "https://api.spotify.com/v1/playlists/37i9dQZF1DX5FuBDzVtEFX";
//                id = 37i9dQZF1DX5FuBDzVtEFX;
//                images =                 (
//                                        {
//                        height = "<null>";
//                        url = "https://i.scdn.co/image/ab67706f0000000307933b1a16a03eba88db7268";
//                        width = "<null>";
//                    }
//                );
//                name = "Hawaiian Dreams";
//                owner =                 {
//                    "display_name" = Spotify;
//                    "external_urls" =                     {
//                        spotify = "https://open.spotify.com/user/spotify";
//                    };
//                    href = "https://api.spotify.com/v1/users/spotify";
//                    id = spotify;
//                    type = user;
//                    uri = "spotify:user:spotify";
//                };
//                "primary_color" = "<null>";
//                public = "<null>";
//                "snapshot_id" = MTYyOTQxNzYwMCwwMDAwMDAyYzAwMDAwMTdiNjBkYjc0ODAwMDAwMDE2ZDAwYmRhYWZk;
//                tracks =                 {
//                    href = "https://api.spotify.com/v1/playlists/37i9dQZF1DX5FuBDzVtEFX/tracks";
//                    total = 52;
//                };
//                type = playlist;
//                uri = "spotify:playlist:37i9dQZF1DX5FuBDzVtEFX";
//            }
//        );
//        limit = 3;
//        next = "https://api.spotify.com/v1/browse/featured-playlists?country=PH&timestamp=2021-09-02T02%3A59%3A22&offset=3&limit=3";
//        offset = 0;
//        previous = "<null>";
//        total = 11;
//    };
//}
