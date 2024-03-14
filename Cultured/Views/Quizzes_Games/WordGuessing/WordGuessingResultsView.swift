//
//  WordGuessingResultsView.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/13/24.
//

import SwiftUI

struct WordGuessingResultsView: View {
    @ObservedObject var vm: WordGuessingViewModel
    
    var body: some View {
        ZStack(alignment: .topLeading) { // Use ZStack to overlay elements
            RoundedRectangle(cornerRadius: 14.0)
                .foregroundColor(.white)
                .frame(width: 304, height: 532)
            
            Text("Results")
                .font(.title)
                .padding([.top, .leading], 20)
        }
    }
}

#Preview {
    WordGuessingResultsView(vm: WordGuessingViewModel())
}
