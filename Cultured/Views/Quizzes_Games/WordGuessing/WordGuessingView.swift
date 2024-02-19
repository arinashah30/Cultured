//
//  WordGuessingView.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/13/24.
//

import SwiftUI

struct WordGuessingView: View {
    @ObservedObject var vm: WordGuessingViewModel
        
    var body: some View {
        VStack {
            if let game = vm.current_word_guessing_game {
                
                Text(game.title)
                    .font(.title)
                    .padding()
                
                Text("Points: \(game.totalPoints)")
                    .padding()
                
                Text("Flips done: \(game.flipsDone)")
                    .padding()
                
                Text("Guesses: \(game.numberOfGuesses)")
                    .padding()
                
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                    ForEach(game.options.indices, id: \.self) { index in
                        Button(action: {
                            vm.flipTile()
                        }) {
                            Text(game.options[index])
                                .foregroundColor(.white)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                                .background(.blue)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            } else {
                Text("No game available")
                .padding()
            }
        }
        .onAppear {
            vm.create_mock_wg_game()
        }
    }
}

#Preview {
    WordGuessingView(vm: WordGuessingViewModel())
}


/*
 TODO:
 - view not updating based on view model logic
 - create text box to submit answers
 - options don't show unless tile is flipped
 */
