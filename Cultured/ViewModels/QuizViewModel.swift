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
    @Published var viewModel: ViewModel
    @Published var current_quiz: Quiz? = Quiz(title: "Test Quiz",
    questions: [QuizQuestion(question: "What is the answer?", answers: ["Answer1", "Answer2", "Answer3", "Answer4"], correctAnswer: 1, correctAnswerDescription: "This is correct", submitted: false), QuizQuestion(question: "What is the answer?", answers: ["Answer1", "Answer2", "Answer3", "Answer4"], correctAnswer: 1, correctAnswerDescription: "This is correct", submitted: false),QuizQuestion(question: "What is the answer?", answers: ["Answer1", "Answer2", "Answer3", "Answer4"], correctAnswer: 1, correctAnswerDescription: "This is correct", submitted: false),QuizQuestion(question: "What is the answer?", answers: ["Answer1", "Answer2", "Answer3", "Answer4"], correctAnswer: 1, correctAnswerDescription: "This is correct", submitted: false),QuizQuestion(question: "What is the answer?", answers: ["Answer1", "Answer2", "Answer3", "Answer4"], correctAnswer: 1, correctAnswerDescription: "This is correct", submitted: false)],
    points: 20, currentQuestion: 1, history: ["Answer1"])
    
    init(current_user: User? = nil, viewModel: ViewModel, current_quiz: Quiz? = nil) {
        self.current_user = current_user
        self.viewModel = viewModel
        self.current_quiz = current_quiz
    }
    
    func start_quiz(category: String) {
        viewModel.getOnGoingActivity(userId: current_user!.id, type: "quiz", completion: { currentActivities in
            self.viewModel.getQuizFromFirebase(activityName: "\(self.current_user!.country)\(category)Quiz", completion: { quizInfo in
                if let quizInfo = quizInfo {
                    if let currentActivities = currentActivities {
                        // history will be currentActivities["\(self.current_user!.country)\(category)Quiz"]["history"]
                        
                        var i = 0
                        var points = 0
                        for historyItem in currentActivities["\(self.current_user!.country)\(category)Quiz"]["history"] {
                            if historyItem == quizInfo.questions[i].answers[quizInfo.questions[i].correctAnswer] {
                                points += 10
                            }
                            i += 1
                        }
                        
                        Quiz(title: quizInfo.title, questions: quizInfo.questions, points: points, history: [], currentQuestion: currentActivities["\(self.current_user!.country)\(category)Quiz"]!)
                    }
                }
            })
        })
    }
    // the current question: the first stored question or is this *the question the user left of on when they close the app*
    func get_current_question() -> QuizQuestion {
        return current_quiz!.questions[current_quiz!.currentQuestion]
    }
    // moves user to next question after they submit their answer
    func get_next_question() -> QuizQuestion {
        current_quiz?.currentQuestion += 1
            return current_quiz!.questions[current_quiz!.currentQuestion]
        }
    
    func get_answer_choices() -> [String] {
        return (current_quiz?.questions[current_quiz!.currentQuestion].answers)!
    }
    
    func submit_answer(selectedAnswer: String) {
        guard let currentQuestion = current_quiz?.questions[current_quiz!.currentQuestion] else {
               return
           }
           if selectedAnswer == currentQuestion.answers[currentQuestion.correctAnswer] {
               current_quiz?.points += 10
           }
           current_quiz?.questions[current_quiz!.currentQuestion].submitted = true
       }
    
    func finish_quiz() {
        // add points function from FB
        // Calculate total points earned
            guard let quiz = current_quiz else {
                return
            }

            var totalPoints = 0
            for question in quiz.questions {
                if question.submitted {
                    totalPoints += question.submitted ? 10 : 0 // Add 10 points for each correctly submitted question?
                }
            }

            // Update user's points in Firebase
            guard let currentUserID = current_user?.id else {
                return
            }

        viewModel.update_points(userID: currentUserID, pointToAdd: totalPoints) { success in
            }
        }
    }
