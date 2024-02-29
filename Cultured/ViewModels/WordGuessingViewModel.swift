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
    @Published var guessesMade: [String] = ["guess1", "guess2", "guess3", "guess4"]
    
    func create_mock_wg_game() {
        print("creating a new game...")
        let options = [
            OptionTile(option: "a"),
            OptionTile(option: "b"),
            OptionTile(option: "c"),
            OptionTile(option: "d"),
            OptionTile(option: "e"),
            OptionTile(option: "f"),
            OptionTile(option: "g"),
            OptionTile(option: "h"),
            OptionTile(option: "i")
        ]
        let answer = "j"
        startNewGame(options: options, answer: answer)
        print("new game created successfully!")
    }
    
    func startNewGame(options: [OptionTile], answer: String, title: String = "Guess the Word") {
        current_word_guessing_game = WordGuessing(
            title: title,
            options: options,
            answer: answer
        )
        current_word_guessing_game?.options[0].isFlipped = true
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
            game.numberOfGuesses = 2
            current_word_guessing_game = game
        }
    }
    
    func submitGuess(_ currentGuess: String) {
        guard var game = current_word_guessing_game else { return }
        if game.numberOfGuesses == 0 && game.flipsDone < game.options.count - 1 {
            return promptUser()
        }
        
        game.numberOfGuesses -= 1
        
        if currentGuess.lowercased() == game.answer.lowercased() {
            winGame()
        } else {
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
        print(game.answer + " was the correct word. You Win!!")
    }
        
    func loseGame() {
        guard var game = current_word_guessing_game else { return }
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
