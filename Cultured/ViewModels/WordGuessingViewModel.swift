//
//  WordGuessingViewModel.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/13/24.
//

import Foundation

class WordGuessingViewModel: ObservableObject {
    @Published var current_user: User? = nil
    @Published var current_word_guessing_game: WordGuessing? = nil
    
    func create_mock_wg_game() {
        let options = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
        let answer = "j"
        current_word_guessing_game = WordGuessing(title: "Mock Game for Testing", options: options, answer: answer)
    }
    
    func startNewGame(options: [String], answer: String, title: String = "New Game") {
        current_word_guessing_game = WordGuessing(title: title, options: options, answer: answer)
    }
    
    func flipTile() {
        guard var game = current_word_guessing_game else { return }
        game.totalPoints -= game.flipPoints
        game.flipsDone += 1
        current_word_guessing_game = game
    }
    
    func submitGuess(_ currentGuess: String) {
        guard var game = current_word_guessing_game else { return }
        game.numberOfGuesses -= 1
        
        if currentGuess.lowercased() == game.answer.lowercased() {
            winGame()
        } else {
            game.totalPoints -= game.flipPoints
            if game.numberOfGuesses <= 0 {
                loseGame()
            }
        }
        current_word_guessing_game = game
    }
    
    func winGame() {
        print("W")
    }
        
    func loseGame() {
        print("L")
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
