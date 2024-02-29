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
    let colors: [Color] = [.red, .blue, .green, .orange, .yellow, .purple, .pink, .gray, .pink]
        
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
//                        vm.flipTile()
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
                                Text(game.options[index].option)
                                    .foregroundColor(.black)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                                    .background(colors[index % colors.count])
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            } else {
                                Text(game.options[index].option)
                                    .foregroundColor(.black)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                                    .background(.green)
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding()
                }
                
                HStack {
                    Spacer(minLength: 20)
                    TextField("Type your guess...", text: $currentGuess)
                        .padding(9)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(Color.gray, lineWidth: 2)
                                )
                    Button("Enter") {
                        vm.submitGuess(currentGuess)
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


/*
 TODO:
 - options don't show unless tile is flipped
 - 
 */
