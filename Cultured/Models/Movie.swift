//
//  Movie.swift
//  Cultured
//
//  Created by Datta Kansal on 4/5/24.
//

import Foundation

struct MovieResults: Decodable {
    let page: Int
    let results: [MovieItem]
    let total_pages: Int
    let total_results: Int
}

struct MovieItem: Identifiable, Decodable {
    let adult: Bool
    let id: Int
    let poster_path: String
    let title: String
    let vote_average: Float
    
    var moviePoster: URL? {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w500")
        return baseURL?.appending(path: poster_path)
    }
}
    
struct ActorResults: Decodable {
    let page: Int
    let results: [ActorItem]
    let total_pages: Int
    let total_results: Int
}

struct ActorItem: Identifiable, Decodable {
    let adult: Bool
    let id: Int
    let profile_path: String
    let name: String
    let popularity: Float
    
    var actorProfile: URL? {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w500")
        return baseURL?.appending(path: profile_path)
    }
}

