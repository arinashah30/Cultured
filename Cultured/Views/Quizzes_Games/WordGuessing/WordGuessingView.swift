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
    

    let colors: [Color] = [Color("Gradient1"), Color("Gradient2"), Color("Gradient3"), Color("Gradient4"), Color("Gradient5"), Color("Gradient6"), Color("Gradient6"), Color("Gradient6"), Color("Gradient6")]
        
    var body: some View {
        Spacer()
        VStack {
            if let game = vm.current_word_guessing_game {
                Spacer()
                Text(game.title)
                    .font(.title)
                    .padding()
                HStack{
                    Spacer(minLength: 20)
                    Text("Hints")
                        .font(.title2)
                    Spacer(minLength: 190)
                    
                    Button(action: {
                        vm.flipTile()
                    }) {
                        Text("Next hint")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                    Spacer(minLength: 20)
                }
                
                ScrollView {
                    VStack {
                        ForEach(game.options.indices, id: \.self) { index in
                            if (!game.options[index].isFlipped) {
                                Text("")
                                    .foregroundColor(.black)
                                    .frame(width: 336 - CGFloat((23 * index)), height: 51)
                                    .background(colors[index % colors.count])
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                    .padding(.bottom, 10)
                            } else {
                                Text(game.options[index].option)
                                    .foregroundColor(.black)
                                    .frame(width: 336 - CGFloat((23 * index)), height: 51)
                                    .background(colors[index % colors.count])
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                    .padding(.bottom, 10)
                            }
                        }
                    }
                    .padding()
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(vm.guessesMade, id: \.self) { guess in
                                Text(guess)
                                    .foregroundColor(.red.opacity(0.5))
                                    .padding()
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 50)
                
                HStack {
                    Spacer(minLength: 20)
                    TextField("Type your guess...                 \(vm.current_word_guessing_game?.numberOfGuesses ?? 0) left", text: $currentGuess)
                        .keyboardType(.default)
                        .padding(9)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(Color.gray, lineWidth: 2)
                                )
                    Button("Enter") {
                        if currentGuess != "" {
                            vm.submitGuess(currentGuess)
                        }
                        currentGuess = ""
                    }
                    .foregroundColor(.black)
                    .frame(minWidth: 0, maxWidth: 71, minHeight: 45)
                    .background(Color("EnterButtonColor"))
                    .cornerRadius(10)
                    Spacer(minLength: 20)
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

