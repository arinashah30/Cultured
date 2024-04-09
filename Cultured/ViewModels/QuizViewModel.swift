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
    var quizzes: [String: Quiz] = [:]
    @Published var current_quiz: Quiz? = nil
    @Published var viewModel: ViewModel
    let categories = ["Culture", "Food", "Customs", "Places"]
    
    init (viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    func load_quizzes(completion: @escaping (Bool) -> Void) {
        //print("OMG I WAS CALLED!!!!")
        //print(viewModel.current_user )
        //print(viewModel.current_user!.country)
        if viewModel.current_user != nil && !viewModel.current_user!.country.isEmpty {
            var activityNames = categories
            var i = 0
            for activity in activityNames {
                activityNames[i] = "\(self.viewModel.current_user!.country)\(activity)Quiz"
                i += 1
            }
            print(activityNames)
            viewModel.getOnGoingActivities(userId: viewModel.current_user!.id, type: "quiz", completion: { activities in
                for activity in activityNames {
                    self.viewModel.getQuizFromFirebase(activityName: activity, completion: { quizInfo in
                        if var quizInfo = quizInfo {
                            var i = 0
                            var points = 0
                            if let activityHistory = activities[activity] {
                                for historyItem in activityHistory["history"] as! [String] {
                                    if historyItem == quizInfo.questions[i].answers[quizInfo.questions[i].correctAnswer] {
                                        points += 10
                                        quizInfo.questions[i].submitted = true
                                    }
                                    i += 1
                                }
                                quizInfo.currentQuestion = activities[activity]!["current"] as! Int
                                quizInfo.points = points
                                quizInfo.history = activityHistory["history"] as! [String]
                            }
                            self.quizzes[activity] = quizInfo
                        }
                    })
                }
            })
            completion(true)
        }
    }
    
    func start_quiz(category: String) {
        current_quiz = quizzes["\(viewModel.current_user!.country)\(category)Quiz"]
    }
    
    func get_current_question() -> QuizQuestion {
        return current_quiz!.questions[current_quiz!.currentQuestion]
    }
    
    func get_next_question() -> QuizQuestion {
        if current_quiz!.currentQuestion < current_quiz!.questions.count - 1 {
            current_quiz?.currentQuestion += 1
        }
        return current_quiz!.questions[current_quiz!.currentQuestion]
    }
    
    func next_question() {
        if current_quiz!.currentQuestion < current_quiz!.questions.count - 1 {
            current_quiz?.currentQuestion += 1
        }
    }
    
    func move_to_results () -> Bool {
        print("MOVING TO RESULTS?")
        print(current_quiz!.currentQuestion == current_quiz!.questions.count - 1)
        print(current_quiz!.questions[current_quiz!.questions.count - 1].submitted)
        print(current_quiz!.currentQuestion == current_quiz!.questions.count - 1 && current_quiz!.questions[current_quiz!.questions.count - 1].submitted)
        return current_quiz!.currentQuestion == current_quiz!.questions.count - 1 && current_quiz!.questions[current_quiz!.questions.count - 1].submitted
    }
    
    func get_answer_choices() -> [String] {
        return (current_quiz?.questions[current_quiz!.currentQuestion].answers)!
    }
    
    func submit_answer(selectedAnswer: String, completion: @escaping () -> ()) {
        current_quiz!.questions[current_quiz!.currentQuestion].submitted = true
        //currentQuestion.submitted = true
        var currentQuestion = get_current_question()
        if selectedAnswer == currentQuestion.answers[currentQuestion.correctAnswer] {
            current_quiz!.points += 10
        }
        current_quiz?.history.append(selectedAnswer)
        //current_quiz?.currentQuestion += 1
        viewModel.updateHistory(userID: viewModel.current_user!.id, activity: current_quiz!.title, history: current_quiz!.history, completion: { _ in
            //completion()
        })
        viewModel.incrementCurrent(userID: viewModel.current_user!.id, activityName: current_quiz!.title, completion: { _ in
            completion()
        })
    }
    
    func check_answer(selected: String) -> returnValues {
        let currentQuestion = current_quiz!.questions[current_quiz!.currentQuestion]
        if (!currentQuestion.answers.contains(selected)) {
            return .invalid("This option is not in the options")
        }
        return .success(selected == currentQuestion.answers[currentQuestion.correctAnswer])
    }
    
    func getProgress() -> [Float] {
        let quiz1Progress = Float(quizzes["\(viewModel.current_user!.country)\(categories[0])Quiz"]?.currentQuestion ?? 0) / Float(quizzes["\(viewModel.current_user!.country)\(categories[0])Quiz"]?.questions.count ?? 1)
            let quiz2Progress = Float(quizzes["\(viewModel.current_user!.country)\(categories[1])Quiz"]?.currentQuestion ?? 0) / Float(quizzes["\(viewModel.current_user!.country)\(categories[1])Quiz"]?.questions.count ?? 1)
            let quiz3Progress = Float(quizzes["\(viewModel.current_user!.country)\(categories[2])Quiz"]?.currentQuestion ?? 0) / Float(quizzes["\(viewModel.current_user!.country)\(categories[2])Quiz"]?.questions.count ?? 1)
            let quiz4Progress = Float(quizzes["\(viewModel.current_user!.country)\(categories[3])Quiz"]?.currentQuestion ?? 0) / Float(quizzes["\(viewModel.current_user!.country)\(categories[3])Quiz"]?.questions.count ?? 1)
            
            print([quiz1Progress, quiz2Progress, quiz3Progress, quiz4Progress])
            return [quiz1Progress, quiz2Progress, quiz3Progress, quiz4Progress]
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
        guard let currentUserID = viewModel.current_user?.id else {
            return
        }
        
        viewModel.update_points(userID: currentUserID, pointToAdd: totalPoints) { success in
        }
    }
    
    func get_current_category() -> String {
        return (current_quiz?.title.replacingOccurrences(of: "\(viewModel.current_user!.country)", with: "").replacingOccurrences(of: "Quiz", with: ""))!
    }
}

enum returnValues {
    case success(Bool)
    case invalid(String)
    
    var result: Bool {
            switch self {
            case .success(let isS):
                return isS
            case .invalid:
                return false
            }
        }
    
    var isSuccess: Bool {
            switch self {
            case .success:
                return true
            case .invalid:
                return false
            }
        }
}
