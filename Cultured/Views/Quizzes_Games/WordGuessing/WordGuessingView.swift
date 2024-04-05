//
//  WordGuessingView.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/13/24.
//

import SwiftUI
import PopupView

struct WordGuessingView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: WordGuessingViewModel
    @State private var currentGuess: String = ""
    @State private var localHasWon: Bool = false
    

    let colors: [Color] = [Color("Gradient1"), Color("Gradient2"), Color("Gradient3"), Color("Gradient4"), Color("Gradient5"), Color("Gradient6"), Color("Gradient7"), Color("Gradient8"), Color("Gradient9")]
        
    var body: some View {
        NavigationStack {
            VStack {
                if let game = vm.current_word_guessing_game {
                    HStack {
                        Button {
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .padding(.top, 5)
                                    .padding(.leading, 20)
                                    .foregroundColor(Color.black.opacity(0.1))
                                Image("Arrow")
                                    .padding(.top, 5)
                                    .padding(.leading, 18)
                            }
                        }
                        .padding(.trailing, 300)
                    }
                    Spacer(minLength: 15)
                    HStack{
                        Spacer(minLength: 20)
                        Text("Hints")
                            .font(Font.custom("Quicksand-Medium", size: 24))
                        Spacer(minLength: 190)
                        
                        Button(action: {
                            vm.flipTile()
                        }) {
                            Text("Next hint")
                                .font(.title3)
                                .foregroundColor(.gray)
                                .font(Font.custom("SF-Pro-Display-Light", size: 18))
                        }
                        Spacer(minLength: 20)
                    }
                    
                    ScrollView {
                        VStack {
                            ForEach(game.options.indices, id: \.self) { index in
                                if (!game.options[index].isFlipped) {
                                    Text("")
                                        .foregroundColor(.black)
                                        .frame(width: 129 + CGFloat((23 * index)), height: 51)
                                        .background(colors[index % colors.count])
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                        .padding(.bottom, 10)
                                } else {
                                    Text(game.options[index].option)
                                        .font(Font.custom("SF-Pro-Display-Light", size: 19))
                                        .foregroundColor(.black)
                                        .frame(width: 129 + CGFloat((23 * index)), height: 51)
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
                        TextField("Type your guess...", text: $currentGuess)
                            .font(Font.custom("SF-Pro-Display-Light", size: 19))
                            .keyboardType(.default)
                            .padding(9)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                        Button("Enter") {
                            if currentGuess != "" && vm.current_word_guessing_game?.numberOfGuesses != 0 {
                                vm.submitGuess(currentGuess)
                            }
                            currentGuess = ""
                        }
                        .disabled(vm.current_word_guessing_game?.numberOfGuesses ?? 0 <= 0)
                        .font(Font.custom("SF-Pro-Display-Light", size: 19))
                        .foregroundColor(.black)
                        .frame(minWidth: 0, maxWidth: 71, minHeight: 45)
                        .background(vm.current_word_guessing_game?.numberOfGuesses ?? 0 > 0 ? Color("EnterButtonColor") : Color.black.opacity(0.1))
                        .cornerRadius(10)
                        Spacer(minLength: 20)
                    }
                } else {
                    Text("No game available")
                        .padding()
                }
            }
            .onAppear {
                vm.create_mock_wg_game()
            }
            .onReceive(vm.$hasWon) { newHasWon in
                        self.localHasWon = newHasWon
                    }
            .popup(isPresented: $vm.isOver) {
                ZStack {
                    WordGuessingResultsView(vm: vm)
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    WordGuessingView(vm: WordGuessingViewModel())
}
