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
    let images: [SpotifyImageObject]?
    let popularity: Int?
    let uri: String?
}

struct Song {
    let name: String
    let artists: [Artist]
    let albumName: String
    let albumImageURL: URL?
    let spotifyURL: URL?
    let previewURL: URL?
    
    var artistNames: String {
        return artists.map { $0.name }.joined(separator: ", ")
    }
}

struct Artist: Hashable {
    let name: String
    var imageURL: URL? = nil
    let popularity: Int?
    var spotifyURL: URL? = nil
    
    init(artist: SpotifyArtistObject) {
        self.name = artist.name
        self.popularity = artist.popularity
        if let url = artist.images?.last?.urlString {
            self.imageURL = URL(string: url)
        }
        if let uri = artist.uri {
            self.spotifyURL = URL(string: "http://open.spotify.com/artist/\(uri.split(separator: ":")[2])")
        }
    }
}
