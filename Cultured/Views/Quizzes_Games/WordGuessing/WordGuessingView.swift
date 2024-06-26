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
    @State var localHasWon: Bool = false
    

    let colors: [Color] = [Color("Gradient1"), Color("Gradient2"), Color("Gradient3"), Color("Gradient4"), Color("Gradient5"), Color("Gradient6"), Color("Gradient7"), Color("Gradient8"), Color("Gradient9")]
    
        
    var body: some View {
        NavigationStack {
            VStack {
                if let game = vm.current_word_guessing_game {
                    HStack {
                        VStack {
                            BackButton()
                                //.padding()
                                //.position(y:UIScreen.main.bounds.size.height/250)
                            
                                //.frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.size.height/250, alignment: .topLeading)
                            
                            
                            Text("Hints")
                                .font(Font.custom("Quicksand-Medium", size: 24))
                                .padding()
                                .padding(.leading, 20)
                        }
                        .frame(alignment: .topLeading)
                        
                        Spacer()
                        
                        Button(action: {
                            vm.flipTile() {}
                        }) {
                            Text("Next hint")
                                .font(.title3)
                                .foregroundColor(.gray)
                                .font(Font.custom("SF-Pro-Display-Light", size: 18))
                                .padding(.top, 110)
                                .padding(.trailing, 20)
                        }
                        .disabled(vm.current_word_guessing_game!.current >= vm.current_word_guessing_game!.options.count - 1)
                        //Spacer(minLength: 20)
                    }
                    .frame(alignment: .topLeading)
                    .offset(y: -40)
                    
                    
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
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
//                        .padding()
                    }
                    .offset(y: -25)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(self.vm.get_reversed_history(), id: \.self) { guess in
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
                            if currentGuess != "" && vm.current_word_guessing_game!.history.count < vm.current_word_guessing_game!.current + 1 {
                                vm.submitGuess(currentGuess) { result in
                                    localHasWon = result
                                }
                            }
                            currentGuess = ""
                        }
                        .disabled(vm.current_word_guessing_game!.history.count == vm.current_word_guessing_game!.current + 1)
                        .font(Font.custom("SF-Pro-Display-Light", size: 19))
                        .foregroundColor(.black)
                        .frame(minWidth: 0, maxWidth: 71, minHeight: 45)
                        .background(vm.current_word_guessing_game!.history.count == vm.current_word_guessing_game!.current ? Color("EnterButtonColor") : Color.black.opacity(0.1))
                        .cornerRadius(10)
                        Spacer(minLength: 20)
                    }
                } else {
                    Text("No game available")
                        .padding()
                }
            }
            .popup(isPresented: $localHasWon) {
                ZStack {
                    WordGuessingResultsView(vm: vm)
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    WordGuessingView(vm: WordGuessingViewModel(viewModel: ViewModel()))
}
