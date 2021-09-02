//
//  RecentlyPlayedTracksResponse.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/2/21.
//

import Foundation

struct RecentlyPlayedTracksResponse: Codable {
    let items: [RecentTracks]
    let next: String
    let cursors: [String: String]
    let limit: Int
    let href: String
}

struct RecentTracks: Codable {
    let track: AudioTrack
}




//{
//    cursors =     {
//        after = 1629602975963;
//        before = 1629602933823;
//    };
//    href = "https://api.spotify.com/v1/me/player/recently-played?limit=2";
//    items =     (
//                {
//            context =             {
//                "external_urls" =                 {
//                    spotify = "https://open.spotify.com/playlist/37i9dQZF1DWY90iCJMKual";
//                };
//                href = "https://api.spotify.com/v1/playlists/37i9dQZF1DWY90iCJMKual";
//                type = playlist;
//                uri = "spotify:playlist:37i9dQZF1DWY90iCJMKual";
//            };
//            "played_at" = "2021-08-22T03:29:35.963Z";
//            track =             {
//                album =                 {
//                    "album_type" = single;
//                    artists =                     (
//                                                {
//                            "external_urls" =                             {
//                                spotify = "https://open.spotify.com/artist/27Sc6OmJmvUzQMr1Jg3mIi";
//                            };
//                            href = "https://api.spotify.com/v1/artists/27Sc6OmJmvUzQMr1Jg3mIi";
//                            id = 27Sc6OmJmvUzQMr1Jg3mIi;
//                            name = Exiz;
//                            type = artist;
//                            uri = "spotify:artist:27Sc6OmJmvUzQMr1Jg3mIi";
//                        }
//                    );
//                    "available_markets" =                     (
//                        AD,
//                        
//                        ZM,
//                        ZW
//                    );
//                    "external_urls" =                     {
//                        spotify = "https://open.spotify.com/album/5KmNhTJ2oYiZ1sbzt7fmiD";
//                    };
//                    href = "https://api.spotify.com/v1/albums/5KmNhTJ2oYiZ1sbzt7fmiD";
//                    id = 5KmNhTJ2oYiZ1sbzt7fmiD;
//                    images =                     (
//                                                {
//                            height = 640;
//                            url = "https://i.scdn.co/image/ab67616d0000b2736fdaa833c134c7a00286d0d5";
//                            width = 640;
//                        },
//                                                {
//                            height = 300;
//                            url = "https://i.scdn.co/image/ab67616d00001e026fdaa833c134c7a00286d0d5";
//                            width = 300;
//                        },
//                                                {
//                            height = 64;
//                            url = "https://i.scdn.co/image/ab67616d000048516fdaa833c134c7a00286d0d5";
//                            width = 64;
//                        }
//                    );
//                    name = Paramdam;
//                    "release_date" = "2021-07-30";
//                    "release_date_precision" = day;
//                    "total_tracks" = 1;
//                    type = album;
//                    uri = "spotify:album:5KmNhTJ2oYiZ1sbzt7fmiD";
//                };
//                artists =                 (
//                                        {
//                        "external_urls" =                         {
//                            spotify = "https://open.spotify.com/artist/27Sc6OmJmvUzQMr1Jg3mIi";
//                        };
//                        href = "https://api.spotify.com/v1/artists/27Sc6OmJmvUzQMr1Jg3mIi";
//                        id = 27Sc6OmJmvUzQMr1Jg3mIi;
//                        name = Exiz;
//                        type = artist;
//                        uri = "spotify:artist:27Sc6OmJmvUzQMr1Jg3mIi";
//                    }
//                );
//                "available_markets" =                 (
//                    AD,
//                    AE,
//
//                    ZM,
//                    ZW
//                );
//                "disc_number" = 1;
//                "duration_ms" = 276050;
//                explicit = 0;
//                "external_ids" =                 {
//                    isrc = FRX282162808;
//                };
//                "external_urls" =                 {
//                    spotify = "https://open.spotify.com/track/35LQPNNntn1AOa3SExFVxz";
//                };
//                href = "https://api.spotify.com/v1/tracks/35LQPNNntn1AOa3SExFVxz";
//                id = 35LQPNNntn1AOa3SExFVxz;
//                "is_local" = 0;
//                name = Paramdam;
//                popularity = 38;
//                "preview_url" = "https://p.scdn.co/mp3-preview/5b1509d6a2503fc39cf67861b234a877087acdc5?cid=43db0c8fac104023a77aace978575ab9";
//                "track_number" = 1;
//                type = track;
//                uri = "spotify:track:35LQPNNntn1AOa3SExFVxz";
//            };
//        },




//                {
//            context =             {
//                "external_urls" =                 {
//                    spotify = "https://open.spotify.com/playlist/37i9dQZF1DX7Jerj8LqApV";
//                };
//                href = "https://api.spotify.com/v1/playlists/37i9dQZF1DX7Jerj8LqApV";
//                type = playlist;
//                uri = "spotify:playlist:37i9dQZF1DX7Jerj8LqApV";
//            };
//            "played_at" = "2021-08-22T03:28:53.823Z";
//            track =             {
//                album =                 {
//                    "album_type" = single;
//                    artists =                     (
//                                                {
//                            "external_urls" =                             {
//                                spotify = "https://open.spotify.com/artist/3xZCL7YJQySq6zYycUfdSv";
//                            };
//                            href = "https://api.spotify.com/v1/artists/3xZCL7YJQySq6zYycUfdSv";
//                            id = 3xZCL7YJQySq6zYycUfdSv;
//                            name = "Jensen Gomez";
//                            type = artist;
//                            uri = "spotify:artist:3xZCL7YJQySq6zYycUfdSv";
//                        }
//                    );
//                    "available_markets" =                     (
//                        AD,
//
//                        ZM,
//                        ZW
//                    );
//                    "external_urls" =                     {
//                        spotify = "https://open.spotify.com/album/0GoEzHgstlXAYwP38jTOnc";
//                    };
//                    href = "https://api.spotify.com/v1/albums/0GoEzHgstlXAYwP38jTOnc";
//                    id = 0GoEzHgstlXAYwP38jTOnc;
//                    images =                     (
//                                                {
//                            height = 640;
//                            url = "https://i.scdn.co/image/ab67616d0000b2739dc5e7505dad52adb4fec945";
//                            width = 640;
//                        },
//                                                {
//                            height = 300;
//                            url = "https://i.scdn.co/image/ab67616d00001e029dc5e7505dad52adb4fec945";
//                            width = 300;
//                        },
//                                                {
//                            height = 64;
//                            url = "https://i.scdn.co/image/ab67616d000048519dc5e7505dad52adb4fec945";
//                            width = 64;
//                        }
//                    );
//                    name = "Phases Vol. 1";
//                    "release_date" = "2021-07-16";
//                    "release_date_precision" = day;
//                    "total_tracks" = 3;
//                    type = album;
//                    uri = "spotify:album:0GoEzHgstlXAYwP38jTOnc";
//                };
//                artists =                 (
//                                        {
//                        "external_urls" =                         {
//                            spotify = "https://open.spotify.com/artist/3xZCL7YJQySq6zYycUfdSv";
//                        };
//                        href = "https://api.spotify.com/v1/artists/3xZCL7YJQySq6zYycUfdSv";
//                        id = 3xZCL7YJQySq6zYycUfdSv;
//                        name = "Jensen Gomez";
//                        type = artist;
//                        uri = "spotify:artist:3xZCL7YJQySq6zYycUfdSv";
//                    }
//                );
//                "available_markets" =                 (
//                    AD,
//
//                    ZW
//                );
//                "disc_number" = 1;
//                "duration_ms" = 251842;
//                explicit = 1;
//                "external_ids" =                 {
//                    isrc = PHUM72100211;
//                };
//                "external_urls" =                 {
//                    spotify = "https://open.spotify.com/track/2GmzYkHqlF9uee6butm207";
//                };
//                href = "https://api.spotify.com/v1/tracks/2GmzYkHqlF9uee6butm207";
//                id = 2GmzYkHqlF9uee6butm207;
//                "is_local" = 0;
//                name = "No Sides";
//                popularity = 45;
//                "preview_url" = "<null>";
//                "track_number" = 2;
//                type = track;
//                uri = "spotify:track:2GmzYkHqlF9uee6butm207";
//            };
//        }
//    );
//    limit = 2;
//    next = "https://api.spotify.com/v1/me/player/recently-played?before=1629602933823&limit=2";
//}
