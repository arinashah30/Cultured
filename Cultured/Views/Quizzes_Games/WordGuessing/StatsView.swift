//
//  StatsView.swift
//  Cultured
//
//  Created by Shreyas Goyal on 3/13/24.
//

import SwiftUI

struct StatsView: View {
    @ObservedObject var vm: WordGuessingViewModel
    @State var localHasWon: Bool = false
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            let adjustedStats = adjustStats(originalStats: vm.stats)
            ForEach(0..<9, id: \.self) { index in
                VStack() {
                    Text(String(vm.stats[index]))
                        .foregroundColor(Color.black.opacity(0.35))
                    if localHasWon && vm.current_word_guessing_game?.flipsDone == index {
                        Rectangle()
                            .frame(width: 25, height: 200 * CGFloat(adjustedStats[index]))
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
    StatsView(vm: WordGuessingViewModel())
}
