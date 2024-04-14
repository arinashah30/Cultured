//
//  WordGuessingResultsView.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/13/24.
//

import SwiftUI

struct WordGuessingResultsView: View {
    @ObservedObject var vm: WordGuessingViewModel
    @State var goHome: Bool = false
//    @State private var localHasWon: Bool = true

    var body: some View {
        ZStack {
            Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
            RoundedRectangle(cornerRadius: 14.0)
                .foregroundColor(.cPopover)
                .frame(width: 304, height: 550)
            

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
                        Text(vm.current_word_guessing_game!.hasWon ? "You guessed it!" : "Nice try...")
                            .font(Font.custom("Quicksand-Medium", size: 18))
                            .foregroundColor(vm.current_word_guessing_game!.hasWon ? Color("WinningText") : .red)
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
                            .foregroundColor(.primary)
                        Text("points")
                            .foregroundColor(Color.primary.opacity(0.5))
                    }
                    VStack {
                        
                        Text(String(vm.getWinPercent()) + "%")
                            .font(Font.custom("Quicksand-Bold", size: 22))
                            .foregroundColor(.primary)
                        Text("Win %")
                            .foregroundColor(Color.primary.opacity(0.5))
                    }
                    Spacer()
                }
                
                HStack(spacing: 35) {
                    Spacer()
                    Text("Hints Used By Everyone")
                        .foregroundColor(.primary.opacity(0.8))
                    Spacer()
                }
                
                HStack(alignment: .bottom, spacing: 4) {
                    Spacer()
                    let adjustedStats = adjustStats(originalStats: vm.current_word_guessing_game!.stats)
                    ForEach(0..<9, id: \.self) { (index: Int) in
                        VStack() {
                            Text(String(vm.current_word_guessing_game!.stats[index]))
                                .foregroundColor(Color.primary.opacity(0.35))
                            if vm.current_word_guessing_game!.current == index && vm.current_word_guessing_game!.hasWon {
                                Rectangle()
                                    .frame(width: 25, height: 190 * CGFloat(adjustedStats[index]))
                                    .foregroundColor(Color("WinningBar"))
                            } else {
                                Rectangle()
                                    .frame(width: 25, height: 200 * CGFloat(adjustedStats[index]))
                                    .foregroundColor(Color.primary.opacity(0.15))
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
                        goHome = true
                    }) {
                        Text("Back to Home")
                            .font(Font.custom("Quicksand-Medium", size: 17))
                            .foregroundColor(.primary.opacity(0.5))
                    }.navigationDestination(isPresented: $goHome, destination: {HomeView(vm: vm.viewModel)})
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
    WordGuessingResultsView(vm: WordGuessingViewModel(viewModel: ViewModel()))
}

