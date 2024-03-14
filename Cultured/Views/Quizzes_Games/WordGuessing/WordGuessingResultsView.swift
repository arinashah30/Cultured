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
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 14.0)
                .foregroundColor(.white)
                .frame(width: 304, height: 532)
                .overlay(
                    RoundedRectangle(cornerRadius: 14.0)
                        .stroke(Color.black, lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Results")
                    .font(Font.custom("Quicksand-Medium", size: 24))
                Text("You guessed it!")
                    .font(Font.custom("Quicksand-Medium", size: 20))
                    .foregroundColor(localHasWon ? Color("WinningText") : .red)
                Text("Answer: word")
                    .font(Font.custom("Quicksand-Medium", size: 20))
                StatsView(vm: vm, localHasWon: localHasWon)
            }
            .padding([.top, .leading], 20)
        }

    }
}

#Preview {
    WordGuessingResultsView(vm: WordGuessingViewModel())
}
