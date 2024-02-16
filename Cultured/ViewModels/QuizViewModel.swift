//
//  QuizViewModel.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/13/24.
//

//get_current_question
//get_answer_choices
//get_next_question
//submit_answer

import Foundation

class QuizViewModel: ObservableObject {
    @Published var current_user: User? = nil
    @Published var current_quiz: Quiz? = nil
    
    func get_current_question() -> QuizQuestion {
        return current_quiz!.questions[current_quiz!.currentQuestion]
    }
    
    func get_next_question() -> QuizQuestion {
        current_quiz?.currentQuestion += 1
        return current_quiz!.questions[current_quiz!.currentQuestion]
    }
    
    func get_answer_choices() -> [String] {
        return (current_quiz?.questions[current_quiz!.currentQuestion].answers)!
    }
    
    func submit_answer(selectedAnswer: String) {
        var currentQuestion = current_quiz!.questions[current_quiz!.currentQuestion]
        if selectedAnswer == currentQuestion.answers[currentQuestion.correctAnswer] {
            current_quiz?.points += 10
        }
        currentQuestion.submitted = true
        UserDefaults.setValue(current_quiz!.currentQuestion + 1, forKey: "currentQuizQuestion")
    }
    
    func start_quiz() {
        var questions: [QuizQuestion] = []
        var answers: [String] = []
        
        for number in 1...4 {
            answers.append("Answer \(number)")
        }
        
        for number in 1...5 {
            questions.append(QuizQuestion(question: "Question \(number)", answers: answers, correctAnswer: Int.random(in: 1...4), correctAnswerDescription: "Correct answer description"))
        }
        
        current_quiz = Quiz(title: "Sample Quiz", questions: questions, points: 0, pointsGoal: 10, currentQuestion: 0)
    }
    
    func finish_quiz() {
        // add points function from FB
    }
}
