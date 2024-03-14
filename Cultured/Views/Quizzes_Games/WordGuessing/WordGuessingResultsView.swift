//
//  WordGuessingResultsView.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/13/24.
//

import SwiftUI

struct WordGuessingResultsView: View {
    @ObservedObject var vm: WordGuessingViewModel
    @State private var localHasWon: Bool = true

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14.0)
                .foregroundColor(.white)
                .frame(width: 304, height: 532)
                .overlay(
                    RoundedRectangle(cornerRadius: 14.0)
                        .stroke(Color.black, lineWidth: 1)
                )

            

            VStack(alignment: .leading, spacing: 25) {
                
                
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Results")
                            .font(Font.custom("Quicksand-Medium", size: 24))
                        HStack() {
                            Spacer()
                            Button(action: {
                                // action to quit
                            }) {
                                Text("X")
                                    .foregroundColor(.black.opacity(0.5))
                            }
                        }
                        .padding(.trailing, 25)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(localHasWon ? "You guessed it!" : "Nice try...")
                            .font(Font.custom("Quicksand-Medium", size: 20))
                            .foregroundColor(localHasWon ? Color("WinningText") : .red)
                        Text("Answer: word")
                            .font(Font.custom("Quicksand-Medium", size: 20))
                    }
                }
                .padding(.top, 20)
                .padding(.leading, 25)
                

                
                
                HStack(spacing: 35) {
                    Spacer()
                    VStack {
                        Text("15")
                            .font(Font.custom("Quicksand-Bold", size: 24))
                            .foregroundColor(.black)
                        Text("points")
                            .foregroundColor(Color.black.opacity(0.5))
                    }
                    VStack {
                        Text("90%")
                            .font(Font.custom("Quicksand-Bold", size: 24))
                            .foregroundColor(.black)
                        Text("Win %")
                            .foregroundColor(Color.black.opacity(0.5))
                    }
                    Spacer()
                }
                
                HStack(spacing: 35) {
                    Spacer()
                    Text("Hints Used By Everyone")
                        .foregroundColor(.black.opacity(0.8))
                    Spacer()
                }
                
                StatsView(vm: vm, localHasWon: localHasWon)
                
                HStack(spacing: 35) {
                    Spacer()
                    Button(action: {
                        // action to go home
                    }) {
                        Text("Back to Home")
                            .font(Font.custom("Quicksand-Medium", size: 19))
                            .foregroundColor(.black.opacity(0.5))
                    }
                    Spacer()
                }
                
                Spacer()
            }
            .frame(width: 304, height: 532, alignment: .topLeading)
        }
    }
}

#Preview {
    WordGuessingResultsView(vm: WordGuessingViewModel())
}

