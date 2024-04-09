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
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    func load_word_guessing_games(completion: @escaping (Bool) -> Void) {
        var categories = ["Culture", "Food", "Customs", "Places"]
        print("word guessing load")
        if viewModel.current_user != nil && !viewModel.current_user!.country.isEmpty {
            print("insid e condtiion")
            viewModel.getOnGoingActivities(userId: viewModel.current_user!.id, type: "wordgame", completion: { activities in
                for activity in activities.keys {
                    print("WOOOOOT")
                    print(activity)
                    if activity.starts(with: self.viewModel.current_user!.country) {
                        self.viewModel.getWordGameFromFirebase(activityName: activity, completion: { wordInfo in
                            if var wordInfo = wordInfo {
                                var i = 0
                                var points = 100
                                var won = false
                                for historyItem in activities[activity]!["history"] as! [String] {
                                    if historyItem != wordInfo.answer {
                                        points -= 10
                                        wordInfo.options[i].isFlipped = true
                                    } else {
                                        won = true
                                    }
                                    i += 1
                                }
                                self.word_guessings[activity] = WordGuessing(title: wordInfo.title, options: wordInfo.options, answer: wordInfo.answer, history: wordInfo.history, stats: wordInfo.stats, won: won, totalPoints: points, current: activities[activity]!["current"] as! Int)
                            }
                        })
                    }
                }
                for category in categories {
                    var wordLoaded = false
                    for word in self.word_guessings.keys {
                        if word.contains(category) {
                            wordLoaded = true
                        }
                    }
                    if !wordLoaded {
                        print(category)
                        self.viewModel.getWordGameFromFirebase(activityName: "\(self.viewModel.current_user!.country)\(category)WordGuessing", completion: { wordInfo in
                            if let wordInfo = wordInfo {
                                print(wordInfo)
                                self.word_guessings[wordInfo.title] = WordGuessing(title: wordInfo.title, options: wordInfo.options, answer: wordInfo.answer, stats: wordInfo.stats)
                                self.word_guessings[wordInfo.title]!.options[0].isFlipped = true
                                //completion(true)
                            }
                        })
                    }
                }
                //completion(true)
            })
        }
    }
    
    func startNewGame(category: String) {
        current_word_guessing_game = word_guessings["\(viewModel.current_user!.country)\(category)WordGuessing"]
    }
    
    func flipTile() {
        guard var game = current_word_guessing_game else { return }
        if game.history.count < game.options.count - 1 {
            game.totalPoints -= 10
            let optionIndex = game.history.count
            game.options[optionIndex].isFlipped = true
        }
    }
    
    func submitGuess(_ currentGuess: String) {
        guard var game = current_word_guessing_game else { return }
        if game.current < game.options.count - 1 {
            return promptUser()
        }
        
        if currentGuess.lowercased() == game.answer.lowercased() {
            winGame()
        } else {
            game.history.append(currentGuess)
            if game.history.count == game.current {
                if (game.current >= game.options.count - 1) {
                    loseGame()
                } else {
                    promptUser()
                }
            }
        }
        current_word_guessing_game = game
    }
    
    func winGame() {
        guard var game = current_word_guessing_game else { return }
        game.isOver = true
        game.hasWon = true
        print(game.answer + " was the correct word. You Win!!")
    }
        
    func loseGame() {
        guard var game = current_word_guessing_game else { return }
        game.isOver = true
        game.hasWon = false
        print("Game Over. The word was " + game.answer)
    }
    
    func promptUser() {
        print("Flip a tile!")
    }
    
    func getWinPercent() -> Int {
        var i = 0
        var total = 0
        for count in current_word_guessing_game!.stats {
            total += count
            if i == 8 {
                return Int(Float(count) / Float(total) * 100)
            }
            i += 1
        }
        return 0
    }
    
}

/*
 game - word guessing game, card flipping style
 number of tiles (not decided yet, list of strings)
 currPoints = totalPoints - flipPoints
 9 tiles, 18 guesses (2 per flip)
 subtract 10 points for each flip
 ordered hints
 win criteria - guessing the right word (lowercase for everything)
 */

struct OptionTile {
    var option: String
    var isFlipped: Bool = false
}
