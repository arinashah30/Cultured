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
            Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
            RoundedRectangle(cornerRadius: 14.0)
                .foregroundColor(.white)
                .frame(width: 304, height: 550)
                .overlay(
                    RoundedRectangle(cornerRadius: 14.0)
                        .stroke(Color.black, lineWidth: 1)
                )

            

            VStack(alignment: .leading, spacing: 10) {
                
                
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Results")
                            .font(Font.custom("Quicksand-Medium", size: 22))
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
                            .font(Font.custom("Quicksand-Medium", size: 18))
                            .foregroundColor(localHasWon ? Color("WinningText") : .red)
                        Text("Answer: " + String(vm.current_word_guessing_game?.answer ?? ""))
                            .font(Font.custom("Quicksand-Medium", size: 18))
                    }
                }
                .padding(.top, 10)
                .padding(.leading, 25)
                

                
                
                HStack(spacing: 35) {
                    Spacer()
                    VStack {
                        Text(String(vm.current_word_guessing_game?.totalPoints ?? 0))
                            .font(Font.custom("Quicksand-Bold", size: 22))
                            .foregroundColor(.black)
                        Text("points")
                            .foregroundColor(Color.black.opacity(0.5))
                    }
                    VStack {
                        Text(String(vm.winPercent) + "%")
                            .font(Font.custom("Quicksand-Bold", size: 22))
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
                
                HStack(alignment: .bottom, spacing: 4) {
                    Spacer()
                            let adjustedStats = adjustStats(originalStats: vm.stats)
                            ForEach(0..<9, id: \.self) { index in
                                VStack() {
                                    Text(String(vm.stats[index]))
                                        .foregroundColor(Color.black.opacity(0.35))
                                    if localHasWon && vm.current_word_guessing_game?.flipsDone == index {
                                        Rectangle()
                                            .frame(width: 25, height: 190 * CGFloat(adjustedStats[index]))
                                            .foregroundColor(Color("WinningBar"))
                                    } else {
                                        Rectangle()
                                            .frame(width: 25, height: 200 * CGFloat(adjustedStats[index]))
                                            .foregroundColor(Color.black.opacity(0.15))
                                    }
                                    Text(String(index + 1))
                                        .foregroundColor(Color.black.opacity(0.5))
                                }
                                
                            }
                    Spacer()
                        }
                
                HStack(spacing: 35) {
                    Spacer()
                    Button(action: {
                        // action to go home
                    }) {
                        Text("Back to Home")
                            .font(Font.custom("Quicksand-Medium", size: 17))
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

func adjustStats(originalStats: [Int]) -> [Float] {
    var maxNum: Int = 9
    if let maxStat = originalStats.max() {
        maxNum = max(maxStat, 9)
    }
    var scaledStats: [Float] = []
    for stat in originalStats {
        scaledStats.append(0.1 + (Float(stat) / Float(maxNum)))
    }
    return scaledStats
}

#Preview {
    WordGuessingResultsView(vm: WordGuessingViewModel())
}

