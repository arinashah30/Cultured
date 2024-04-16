//
//  MovieViewModel.swift
//  Cultured
//
//  Created by Datta Kansal on 4/5/24.
//

import Foundation

class MovieViewModel: ObservableObject {
    let theaterMovieNames: [String] = ["Godzilla x Kong: The New Empire", "Kung Fu Panda 4", "SPY x FAMILY CÓDIGO: Blanco", "Un Actor Malo", "Duna Parte Dos", "La Primera Profecía"]
    let actorNames: [String] //= ["Salma Hayek", "Ricardo Montalban", "Gael Garcia Bernal", "Kate del Castillo", "Ana de la Reguera", "Adriana Barraza"]
    let classicMovieNames: [String]
    @Published var theatermovies: [MovieItem] = []
    @Published var classicmovies: [MovieItem] = []
    @Published var actors: [ActorItem] = []
    static let apiKey = "b7bbe48479f735dcf3fa7ad6bc9cbd1c"
    
    init(actorNames: [String], classicMovieNames: [String]) {
        self.actorNames = actorNames
        self.classicMovieNames = classicMovieNames
    }
    
 func loadMovies() {
        Task {
                do{
                    for name in theaterMovieNames {
                        let url = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&include_adult=false&language=es-mx&page=1&region=mx&api_key=\(MovieViewModel.apiKey)")!
                        let (data, _) = try await URLSession.shared.data(from: url)
                        let movieResults = try? JSONDecoder().decode(MovieResults.self, from: data)
                        if let movieResults {
                            if (!movieResults.results.isEmpty) {
                                theatermovies.append(movieResults.results[0])
                            }
                        }
                    }
                    for name in classicMovieNames {
                        let url = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&include_adult=false&language=es-mx&page=1&region=mx&api_key=\(MovieViewModel.apiKey)")!
                        let (data, _) = try await URLSession.shared.data(from: url)
                        let movieResults = try? JSONDecoder().decode(MovieResults.self, from: data)
                        if let movieResults {
                            if (!movieResults.results.isEmpty) {
                                classicmovies.append(movieResults.results[0])
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
