//
//  WordGuessingViewModel.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/13/24.
//

import Foundation

class WordGuessingViewModel: ObservableObject {
    @Published var word_guessings: [String : WordGuessing] = [:]
    @Published var current_word_guessing_game: WordGuessing? = nil
    @Published var viewModel: ViewModel
    let categories = ["Culture", "Food", "Customs", "Places"]
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    func load_word_guessings(completion: @escaping (Bool) -> Void) {
        if viewModel.current_user != nil && !viewModel.current_user!.country.isEmpty {
            var activityNames = categories
            var i = 0
            for activity in activityNames {
                activityNames[i] = "\(self.viewModel.current_user!.country)\(activity)WordGuessing"
                i += 1
            }
            viewModel.getAllActivitiesOfType(userId: viewModel.current_user!.id, type: "wordgame", completion: { activities in
                for activity in activityNames {
                    //print("Should be getting info for \(activity)")
                    self.viewModel.getWordGameFromFirebase(activityName: activity, completion: { wordInfo in
                        //print("GETTING INFO FOR GAME \(activity)")
                        //print(wordInfo)
                        if var wordInfo = wordInfo {
                            var points = 100
                            if let activityHistory = activities[activity] {
                                
                                for i in 0...(activityHistory["current"] as! Int) {
                                    points -= 10
                                    wordInfo.options[i].isFlipped = true
                                }
                                
                                for historyItem in activityHistory["history"] as! [String] {
                                    if historyItem == wordInfo.answer {
                                        wordInfo.hasWon = true
                                        wordInfo.isOver = true
                                    }
                                }
                                
                                if !wordInfo.hasWon && (activityHistory["current"] as! Int) == 8 {
                                    wordInfo.isOver = true
                                }
                                
                                wordInfo.totalPoints = points
                                wordInfo.history = activityHistory["history"] as! [String]
                                wordInfo.current = activityHistory["current"] as! Int
                            }
                            
                            wordInfo.options[0].isFlipped = true
                            
                            self.word_guessings[activity] = wordInfo
                            //completion(true)
                        }
                    })
                    //completion(true)
                }
                //completion(true)
            })
            //completion(true)
        }
    }
    
    func start_wordguessing(category: String, completion: @escaping () -> ()) {
        current_word_guessing_game = word_guessings["\(viewModel.current_user!.country)\(category)WordGuessing"]
        if current_word_guessing_game!.current == 0 {
            viewModel.addOnGoingActivity(userID: viewModel.current_user!.id, titleOfActivity: current_word_guessing_game!.title, typeOfActivity: "wordgame", completion: { _ in
                completion()
            })
        } else {
            completion()
        }
    }
    
    func flipTile(completion: @escaping () -> ()) {
        guard var game = current_word_guessing_game else { return }
        if !game.hasWon {
            game.current += 1
            viewModel.incrementCurrent(userID: viewModel.current_user!.id, activityName: current_word_guessing_game!.title, completion: { _ in
                if game.current < game.options.count {
                    if game.history.count < game.current {
                        game.history.append("")
                        self.viewModel.updateHistory(userID: self.viewModel.current_user!.id, activity: self.current_word_guessing_game!.title, history: game.history, completion: { _ in
                            game.totalPoints -= 10
                            let optionIndex = game.history.count
                            game.options[optionIndex].isFlipped = true
                            self.current_word_guessing_game = game
                            completion()
                        })
                    } else {
                        game.totalPoints -= 10
                        let optionIndex = game.history.count
                        game.options[optionIndex].isFlipped = true
                        self.current_word_guessing_game = game
                        completion()
                    }
                }
            })
        }
    }
    
    func submitGuess(_ currentGuess: String, completion: @escaping (Bool) -> ()) {
        guard var game = current_word_guessing_game else { return }
        
        if !game.hasWon {
            
            if game.current < game.options.count - 1 {
                promptUser()
            }
            
            game.history.append(currentGuess)
            viewModel.updateHistory(userID: viewModel.current_user!.id, activity: current_word_guessing_game!.title, history: game.history, completion: { _ in
                if currentGuess.lowercased() == game.answer.lowercased() {
                    game.isOver = true
                    game.hasWon = true
                    game.stats[game.current] += 1
                    self.current_word_guessing_game = game
                    self.viewModel.updateWinCountDictionary(nameOfWordgame: self.current_word_guessing_game!.title, hintCount: self.current_word_guessing_game!.current, completion: { _ in
                        self.viewModel.updateCompleted(userID: self.viewModel.current_user!.id, activity: game.title, completed: true, completion: { _ in
                            self.viewModel.updateScore(userID: self.viewModel.current_user!.id, activity: game.title, newScore: game.totalPoints, completion: { _ in
                                self.viewModel.update_points(userID: self.viewModel.current_user!.id, pointToAdd: game.totalPoints, completion: { success in
                                    self.viewModel.current_user!.points = success
                                    completion(true)
                                })
                            })
                        })
                    })
                } else {
                    if (game.history.count >= game.options.count - 1) {
                        game.isOver = true
                        game.hasWon = false
                        game.stats[game.current + 1] += 1
                        self.current_word_guessing_game = game
                        self.viewModel.updateWinCountDictionary(nameOfWordgame: self.current_word_guessing_game!.title, hintCount: self.current_word_guessing_game!.current + 1, completion: { _ in
                            self.viewModel.updateCompleted(userID: self.viewModel.current_user!.id, activity: game.title, completed: true, completion: { _ in
                                self.viewModel.updateScore(userID: self.viewModel.current_user!.id, activity: game.title, newScore: game.totalPoints, completion: { _ in
                                    self.viewModel.update_points(userID: self.viewModel.current_user!.id, pointToAdd: game.totalPoints, completion: { success in
                                        self.viewModel.current_user!.points = success
                                        completion(true)
                                    })
                                })
                            })
                        })
                    } else {
                        self.promptUser()
                        self.current_word_guessing_game = game
                        completion(false)
                    }
                }
                
                //completion(false)
            })
        }
    }
    
    func promptUser() {
        print("Flip a tile!")
    }
    
    func getWinPercent() -> Int {
        var i = 0
        var total = 0
        for count in current_word_guessing_game!.stats {
            total += count
            if i > 8 {
                return Int(Float(total - count) / Float(total) * 100)
            }
            i += 1
        }
        return 0
    }
    
    func getProgress() -> [Float] {
        var progress: [Float] = []
        for category in categories {
            if (Array(word_guessings.keys).firstIndex(of: "\(viewModel.current_user!.country)\(categories[0])WordGuessing") != nil) {
                if word_guessings["\(viewModel.current_user!.country)\(categories[0])WordGuessing"]!.isOver {
                    progress.append(1.0)
                } else {
                    progress.append(Float(word_guessings["\(viewModel.current_user!.country)\(categories[0])WordGuessing"]?.current ?? 0) / Float(9))
                }
            } else {
                progress.append(0.0)
            }
        }
        return progress
    }
    
    func get_reversed_history() -> [String] {
        var returnHistory = current_word_guessing_game!.history
        returnHistory.removeAll(where: {$0 == ""})
        return returnHistory.reversed()
    }
    
}

struct OptionTile {
    var option: String
    var isFlipped: Bool = false
}
