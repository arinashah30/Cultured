//
//  HomeView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var vm: ViewModel
    @State var bindingVar: Bool = false
    var body: some View {
        Text("Home View")
        Button {
            vm.addCompletedQuiz(userID: "dummyUsername_12", quizID: "Cool Games Quiz") {
                boolean in bindingVar = boolean
            }
        } label: {
            Text("Add Completed Quiz")
        }
        
    }
    
}

#Preview {
    HomeView(vm: ViewModel())
}
