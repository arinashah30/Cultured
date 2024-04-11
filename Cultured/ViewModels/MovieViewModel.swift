//
//  MovieViewModel.swift
//  Cultured
//
//  Created by Datta Kansal on 4/5/24.
//

import Foundation

class MovieViewModel: ObservableObject {
    let movieNames: [String] = ["Godzilla x Kong: The New Empire", "Kung Fu Panda 4", "SPY x FAMILY CÓDIGO: Blanco", "Un Actor Malo", "Duna Parte Dos", "La Primera Profecía"]
    let actorNames: [String] = ["Salma Hayek", "Ricardo Montalban", "Gael Garcia Bernal", "Kate del Castillo", "Ana de la Reguera", "Adriana Barraza"]
    @Published var movies: [MovieItem] = []
    @Published var actors: [ActorItem] = []
    static let apiKey = "b7bbe48479f735dcf3fa7ad6bc9cbd1c"
//    static let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiN2JiZTQ4NDc5ZjczNWRjZjNmYTdhZDZiYzljYmQxYyIsInN1YiI6IjY2MDcxM2QyYTZkZGNiMDE2MzQ0ZjM3MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.oWo37m4dRCfuROD9J_1ngTG9jKLmMoKduXPNOjRLrhg"
 func loadMovies() {
        Task {
                do{
                    for name in movieNames {
                        let url = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&include_adult=false&language=es-mx&page=1&region=mx&api_key=\(MovieViewModel.apiKey)")!
                        let (data, _) = try await URLSession.shared.data(from: url)
                        let movieResults = try? JSONDecoder().decode(MovieResults.self, from: data)
                        if let movieResults {
                            if (!movieResults.results.isEmpty) {
                                movies.append(movieResults.results[0])
                            }
                        }
                    }
                } catch {
                    print (error.localizedDescription)
                }
//            }
        }
    }
    
    func loadActors() {
        Task {
            do {
                for name in actorNames {
                    let url = URL(string: "https://api.themoviedb.org/3/search/person?query=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&include_adult=false&language=es-mx&page=1&region=mx&api_key=\(MovieViewModel.apiKey)")!
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let actorResults = try? JSONDecoder().decode(ActorResults.self, from: data)
                    if let actorResults {
                        if (!actorResults.results.isEmpty) {
                            actors.append(actorResults.results[0])
                        }
                    }
                }
            } catch {
                    print (error.localizedDescription)
                }
            }
        }
    }
