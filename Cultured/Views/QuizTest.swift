//
//  QuizTest.swift
//  Cultured
//
//  Created by Andrey Fernandez on 2/15/24.
//

import SwiftUI

struct QuizTest: View {
    @ObservedObject var vm: QuizViewModel
    var body: some View {
        
        Text("Quiz")
        .onAppear {
            vm.start_quiz()
        }
        
        Form {
            Text("Quiz Question: \(vm.current_quiz?.currentQuestion ?? 10)")
            Text("Points: \(vm.current_quiz?.points ?? 10)")
            Text("Question: \(vm.current_quiz?.questions[vm.current_quiz?.currentQuestion ?? 0].question ?? "question")")
        }
        
        Button(action: {
            vm.get_next_question()
        }, label: {
            Text("next question")
        })
    }
}

#Preview {
    QuizTest(vm: QuizViewModel())
}
