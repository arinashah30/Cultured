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
    @Published var guessesMade: [String] = []
    @Published var isOver = false
    @Published var hasWon = false
    @Published var stats: [Int] = [0, 0, 2, 4, 9, 6, 3, 1, 1]
    @Published var winPercent: Int = 90
    
    func create_mock_wg_game() {
        let options = [
            OptionTile(option: "Edible"),
            OptionTile(option: "Italian"),
            OptionTile(option: "Sandwich"),
            OptionTile(option: "Semi-hard"),
            OptionTile(option: "White"),
            OptionTile(option: "Sliced"),
            OptionTile(option: "Rounded"),
            OptionTile(option: "Deli Sub"),
            OptionTile(option: "Cheese")
        ]
        let answer = "Provolone"
        startNewGame(options: options, answer: answer)
    }
    
    func startNewGame(options: [OptionTile], answer: String, title: String = "Guess the Word") {
        current_word_guessing_game = WordGuessing(
            title: title,
            options: options,
            answer: answer
        )
        current_word_guessing_game?.options[0].isFlipped = true
        isOver = false
    }
    
    func flipTile() {
        guard var game = current_word_guessing_game else { return }
        if game.flipsDone < game.options.count - 1 {
            game.totalPoints -= game.flipPoints
            game.flipsDone += 1
            let optionIndex = game.flipsDone
            game.options[optionIndex].isFlipped = true
            //        if (game.totalPoints == 0) {
            //            print("Lose because of points reaching 0")
            //            loseGame()
            //        }
            game.numberOfGuesses = 1
            current_word_guessing_game = game
        }
    }
    
    func submitGuess(_ currentGuess: String) {
        guard var game = current_word_guessing_game else { return }
        if game.numberOfGuesses == 0 && game.flipsDone < game.options.count - 1 {
            return promptUser()
        }
        
        if currentGuess.lowercased() == game.answer.lowercased() {
            winGame()
        } else {
            game.numberOfGuesses -= 1
            guessesMade.insert(currentGuess, at: 0)
            if game.numberOfGuesses == 0 {
                if (game.flipsDone >= game.options.count - 1) {
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
        isOver = true
        hasWon = true
        print(game.answer + " was the correct word. You Win!!")
    }
        
    func loseGame() {
        guard var game = current_word_guessing_game else { return }
        isOver = true
        hasWon = false
        print("Game Over. The word was " + game.answer)
    }
    
    func promptUser() {
        print("Flip a tile!")
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
