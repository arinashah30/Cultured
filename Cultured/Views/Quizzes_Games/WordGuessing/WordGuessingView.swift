//
//  WordGuessingView.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/13/24.
//

import SwiftUI

struct WordGuessingView: View {
    @ObservedObject var vm: WordGuessingViewModel
    @State private var currentGuess: String = ""
        
    var body: some View {
        Spacer()
        VStack {
            if let game = vm.current_word_guessing_game {
                
                Text(game.title)
                    .font(.title)
                    .padding()
                Text("Hints")
                    .font(.title2)
                
//                Text("Points: \(game.totalPoints)")
//                    .padding()
//                
//                Text("Flips done: \(game.flipsDone)")
//                    .padding()
//                
//                Text("Guesses: \(game.numberOfGuesses)")
//                    .padding()
                
                LazyVGrid(columns: [GridItem()]) {
                    ForEach(game.options.indices, id: \.self) { index in
                        // not flipped
                        if (!game.options[index].isFlipped) {
                            Button(action: {
                                vm.flipTile(optionIndex: index)
                            }) {
                                Text(game.options[index].option)
                                    .foregroundColor(.gray)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                                    .border(.gray, width: 3)
                            }
                        } else {
                            // flipped
                            Text(game.options[index].option)
                                .foregroundColor(.white)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                                .background(.pink)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
                
                TextField("Type your guess...", text: $currentGuess)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Submit Guess") {
                    vm.submitGuess(currentGuess)
                    currentGuess = ""
                }
                Spacer()

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
 - create text box to submit answers
 - options don't show unless tile is flipped
 */
