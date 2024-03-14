//
//  Music.swift
//  Cultured
//
//  Created by Gustavo Garfias on 13/03/24.
//

import Foundation

struct SpotifyAccessTokenResponse: Codable {
    let access_token: String
}

struct SpotifyPlaylistAPIResult: Codable {
    let items: [SpotifyPlaylistTrackObject]
}

struct SpotifyPlaylistTrackObject: Codable {
    let track: SpotifyTrackObject
}

struct SpotifyTrackObject: Codable {
    let name: String
    let artists: [SpotifyArtistObject]
    let album: SpotifyAlbum
    let uri: String
    let previewURL: String?
    
    enum CodingKeys: String, CodingKey {
        case name, artists, album, uri
        case previewURL = "preview_url"
    }
}

struct SpotifyAlbum: Codable {
    let name: String
    let images: [SpotifyImageObject]
}

struct SpotifyImageObject: Codable {
    let urlString: String
    
    var url: URL? {
        return URL(string: urlString)
    }
    
    enum CodingKeys: String, CodingKey {
        case urlString = "url"
    }
}

struct SpotifyArtistObject: Codable {
    let name: String
}

struct Song {
    let name: String
    let artists: [String]
    let albumName: String
    let albumImageURL: URL?
    let spotifyURL: URL?
    let previewURL: URL?
}
