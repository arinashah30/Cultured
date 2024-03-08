//
//  ViewModel.swift
//  Cultured
//
//  Created by Arina Shah on 2/5/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ViewModel: ObservableObject {
    @Published var current_user: User? = nil
    let db = Firestore.firestore();
    let auth = Auth.auth();
    @Published var errorText: String? = nil
    //@Published var points: Int = 100
    
    func fireBaseSignIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
            if let error = error{
                completion(false)
            }
            else {
                completion(true)
            }
            //doesn't handle the case where authResult is nil so write that in if needed
            let db = Firestore.firestore()
            let auth = Auth.auth()
        }
    }
            
    func getInfoFromModule(country: String, module: String, completion: @escaping (String?) -> Void) {
        db.collection("COUNTRIES").document(country).getDocument {(doc, error) in
            if let err = error {
                print(err.localizedDescription)
                completion(nil)
                return
            }
            
            guard let document = doc, document.exists else {
                print("no doc")
                completion(nil)
                return
            }
            
            let modules = document.reference.collection("MODULES")
            
            modules.document(module).getDocument {(docu, e) in
                if let e = e {
                    print(e.localizedDescription)
                    completion(nil)
                    return
                }
                guard let modsdoc = docu, modsdoc.exists else {
                    print("no doc")
                    completion(nil)
                    return
                }
                
                let data: [String: Any]? = modsdoc.data()
                
                let moduleInfo: String? = data?[module] as? String
                completion(moduleInfo)
                
            }
            
        }
        
    }
    
    func firebase_email_password_sign_up_(email: String, password: String, username: String, displayName: String) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let errorSignUp = error {
                let firebaseError = AuthErrorCode.Code(rawValue: errorSignUp._code)
                switch firebaseError {
                case .emailAlreadyInUse:
                    self.errorText = "An account with this email already exists"
                case .weakPassword:
                    self.errorText = "This password is too weak"
                default:
                    self.errorText = "An error has occurred"
                }
            } else if let user = authResult?.user {
                self.db.collection("USERS").document(username).setData(
                    ["id" : username,
                     "name" : displayName,
                     "profilePicture" : "https://static-00.iconduck.com/assets.00/person-crop-circle-icon-256x256-02mzjh1k.png", // default icon
                     "email" : email,
                     "points" : 0, //points is a string and we can cast it to an int when we use it
                     "badges" : [],
                     "bio" : "",
                     "friends" : [],
                     "completedGames": [],
                     "incomingRequests": [],
                     "outgoingRequests": [],
                    ] as [String : Any]) { error in
                        if let error = error {
                            self.errorText = error.localizedDescription
                        }
                    }
            }
        }
    }
    
    func update_points(userID: String, pointToAdd: Int, completion: @escaping (Bool) -> Void) {
        db.collection("USERS").document(userID).getDocument { [self] document, error in
            if let err = error {
                print(err.localizedDescription)
                return
            } else {
                if let doc = document {
                    if let data = doc.data() {
                        let points = data["points"] as? Int
                        let totalPoints = (points ?? 0) + pointToAdd
                        db.collection("USERS").document(userID).updateData(["points": totalPoints])  { error in
                            if let error = error {
                                print("Error updating document: \(error.localizedDescription)")
                                completion(false)
                            } else {
                                // Document updated successfully
                                completion(true)
                            }
                        }
                    } else {
                        print("Document data is nil")
                        completion(false)
                    }
                } else {
                    print("Document does not exist")
                    completion(false)
                }
            }
            
        }
    }

    
    func getPts(userID: String, completion: @escaping (Int) -> Void) {
        self.db.collection("USERS").document(userID).getDocument { document, error in
            if let err = error {
                print(err.localizedDescription)
                return
            } else {
                if let doc = document {
                    if let data = doc.data() {
                        print(data)
                        let points = data["points"] as? Int
                        completion(points ?? 0)
                    }
                }
            }
        }
    }
    
    func getBadges(userID: String, completion: @escaping ([String]) -> Void) {
        self.db.collection("USERS").document(userID).getDocument { document, error in
            if let err = error {
                print(err.localizedDescription)
                return
            } else {
                if let doc = document {
                    if let data = doc.data() {
                        let badges = data["badges"] as? [String]
                        completion(badges ?? ["Hello"])
                    }
                }
            }
        }
    }
    
    func createNewCountry(countryName: String) {
        let countryRef = db.collection("COUNTRIES").document(countryName)
        countryRef.setData(["population": 5000])
        
        let modules = [
            "MUSIC",
            "CELEBRITIES",
            "ETIQUETTE",
            "FOOD",
            "HOLIDAYS",
            "LANDMARKS",
            "MAJORCITIES",
            "SPORTS",
            "TRADITIONS",
            "TVMOVIE"
        ]
        
        for module in modules {
            // For each module, create a new document in the "MODULES" subcollection
            countryRef.collection("MODULES").document(module).setData(["someData": "value"])
        }
        
    }
    
    func addBadges(userID: String, newBadge: String, completion: @escaping (Bool) -> Void) {
        db.collection("USERS").document(userID).getDocument { [self] document, error in
            if let err = error {
                print(err.localizedDescription)
                completion(false)
                return
            }
            guard let doc = document else {
                print("Not able to access the document")
                completion(false)
                return
            }
            guard var data = doc.data() else {
                print("Document has no data")
                completion(false)
                return
            }

            
            if var badges = data["badges"] as? [String] {
                badges.append(newBadge)
                data["badges"] = badges
                
                db.collection("USERS").document(userID).updateData(["badges": badges]) { error in
                    if let err = error {
                        print(err.localizedDescription)
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            } else {
                print("No existing badges found")
                completion(false)
            }
        }
    }
    
    func getInfoFromModule(countryName: String, moduleName: String, completion: @escaping (String) -> Void) {
        self.db.collection("COUNTRIES").document(countryName).collection("MODULES").document(moduleName).getDocument { document, error in
            if let err = error {
                print(err.localizedDescription)
                return
            } else {
                if let doc = document {
                    if let data = doc.data() {
                        
                        let info = data["someData"] as? String
                        //                        print (info)
                        if let unwrappedInfo = info {
                            completion(unwrappedInfo)
                        } else {
                            completion("Could Not unwrap info. Could be not a string")
                        }
                    } else {
                        completion("Data for the document does not exist")
                    }
                }
            }
        }                                                                                                            
    }
    func updateScore(userID: String, activity: String, newScore: Int, completion: @escaping (Bool) -> Void) {
        self.db.collection("USERS").document(userID).getDocument { document, error in
            if let err = error {
                print(err.localizedDescription)
                completion(false)
                return
            }
            
            guard let document = document, document.exists else {
                print("no doc")
                completion(false)
                return
            }
            
            let actCollection = document.reference.collection("ACTIVITIES")
            
            actCollection.document(activity).updateData(["score": newScore]){ err in
                if let err = err {
                    print("Error updating document: \(err.localizedDescription)")
                    completion(false)
                } else {
                    // Document updated successfully
                    completion(true)
                }
            }
        }
    }
    
    func updateCompleted(userID: String, activity: String, completed: Bool, completion: @escaping (Bool) -> Void) {
        self.db.collection("USERS").document(userID).getDocument { document, error in
            if let err = error {
                print(err.localizedDescription)
                completion(false)
                return
            }
            
            guard let document = document, document.exists else {
                print("no doc")
                completion(false)
                return
            }
            
            let actCollection = document.reference.collection("ACTIVITIES")
            
            actCollection.document(activity).updateData(["completed": completed]){ err in
                if let err = err {
                    print("Error updating document: \(err.localizedDescription)")
                    completion(false)
                } else {
                    // Document updated successfully
                    completion(true)
                }
            }
        }
    }
    
    func updateHistory(userID: String, activity: String, history: [String], completion: @escaping (Bool) -> Void) {
        self.db.collection("USERS").document(userID).getDocument { document, error in
            if let err = error {
                print(err.localizedDescription)
                completion(false)
                return
            }
            
            guard let document = document, document.exists else {
                print("no doc")
                completion(false)
                return
            }
            
            let actCollection = document.reference.collection("ACTIVITIES")
            
            actCollection.document(activity).updateData(["history": history]){ err in
                if let err = err {
                    print("Error updating document: \(err.localizedDescription)")
                    completion(false)
                } else {
                    // Document updated successfully
                    completion(true)
                }
            }
        }
    }
    
    func updateCurrent(userID: String, activity: String, current: String, completion: @escaping (Bool) -> Void) {
        self.db.collection("USERS").document(userID).getDocument { document, error in
            if let err = error {
                print(err.localizedDescription)
                completion(false)
                return
            }
            
            guard let document = document, document.exists else {
                print("no doc")
                completion(false)
                return
            }
            
            let actCollection = document.reference.collection("ACTIVITIES")
            
            actCollection.document(activity).updateData(["current": current]){ err in
                if let err = err {
                    print("Error updating document: \(err.localizedDescription)")
                    completion(false)
                } else {
                    // Document updated successfully
                    completion(true)
                }
            }
        }
    }

    
    func updateLastLoggedOn(userID: String) {
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let dateInFormat = dateFormatter.string(from: date)
        
        self.db.collection("USERS").document(userID).updateData(["lastLoggedOn": dateInFormat])
        
    }
    
    
    func createNewQuiz(quiz: Quiz) {
        db.collection("GAMES").document(quiz.title).setData(
            ["title": quiz.title,
             "pointsGoal": quiz.pointsGoal,
             "points": quiz.points
            ])
        let quizQuestions = quiz.questions
        let quizRef = db.collection("GAMES").document(quiz.title)
        for question in quizQuestions {
            quizRef.collection("QUESTIONS").document(question.question).setData(
                ["question": question.question,
                 "answerChoices": question.answers,
                 "correctAnswer": String(question.correctAnswer),
                 "correctAnswerDescription": question.correctAnswerDescription,
                ])
        }
    }
    
    func addOnGoingQuiz(userID: String, country: String, titleOfActivity: String, completion: @escaping(Bool) -> Void) {
        db.collection("USERS").document(userID).collection("ACTIVITIES").document("\(country)\(titleOfActivity)").setData(
            ["completed": false,
             
             "current": "",
             
             "history": [],
             
             "score": 0,
            ])
    }
    
    func createNewConnections(connection: Connections) {
        db.collection("GAMES").document(connection.title).setData(
            ["title": connection.title,
             //these are arrays of strings
             "categories": connection.categories,
             "options": connection.options,
             "answerKey": connection.answerKey,
             
             "points": connection.points,
             "attempts": connection.attempts,
            ])
    }
    
    func createNewWordGuessing(wordGuessing: WordGuessing, completion: @escaping (Bool) -> Void) {
        
        let optionsReference = db.collection("GAMES").document(wordGuessing.title)

        optionsReference.setData(
            ["title": wordGuessing.title,
             "answer": wordGuessing.answer,
             "totalPoints": wordGuessing.totalPoints,
             "flipPoints": wordGuessing.flipPoints,
             "flipsDone" : wordGuessing.flipsDone,
             "numberOfGuesses" : wordGuessing.numberOfGuesses,
            ]) { error in
                if let error = error {
                    print("Error writing game document: \(error.localizedDescription)")
                } else {
                    print("Game document successfully written")
                }
            }
        
        let optionTileArray = wordGuessing.options //[OptionTile]
        let optionsArrayReference = optionsReference.collection("OPTIONS")
        for optionTile in optionTileArray {
            print(optionTile)
            optionsArrayReference.document(optionTile.option).setData(
                ["option": optionTile.option,
                 "isFlipped": optionTile.isFlipped,
                ]) { error in
                    if let error = error {
                        print("Error writing option document: \(error.localizedDescription)")
                    } else {
                        print("Option document successfully written")
                    }
                }
        }
        completion(true)
    }
    
    func getQuizFromFirebase(activityName: String, completion: @escaping(Quiz?) -> Void) {
        let documentReference = db.collection("GAMES").document(activityName)
        documentReference.getDocument { (activityDocument, error) in
            if let error = error {
                print("Error Getting Documents \(error)")
                completion(nil)
            } else {
                guard let actDoc = activityDocument, actDoc.exists else {
                    print("Document Does Not Exist")
                    completion(nil)
                    return
                }
                guard let data = actDoc.data() else {
                    completion(nil)
                    return
                }
                let title = data["title"] as? String ?? ""
                let points = data["points"] as? Int ?? 0
                let pointsGoal = data["pointsGoal"] as? Int ?? 0
                //Get the Quiz Questions subcollection
                documentReference.collection("QUESTIONS").getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting the Quiz Questions \(error.localizedDescription)")
                        completion(nil)
                        return
                    }
                    var questionsArray = [QuizQuestion]()
                    for questionsDocuments in querySnapshot!.documents {
                        let questionData = questionsDocuments.data()
                        if let question = self.parseQuestionData(questionData) {
                            questionsArray.append(question)
                        }
                    }
                    let quiz = Quiz(title: title, 
                                    questions: questionsArray,
                                    points: points,
                                    pointsGoal: pointsGoal)
                    completion(quiz)
                }
            }
        }
    }
    
    //Helper Function to Turn the data from Firebase into a Quiz Question
    func parseQuestionData(_ questionData: [String: Any]) -> QuizQuestion? {
        let question = questionData["question"] as? String ?? ""
        let answers = questionData["answerChoices"] as? [String] ?? []
        let correctAnswerIndex = questionData["correctAnswer"] as? Int ?? 0
        let correctAnswerDescription = questionData["correctAnswerDescription"] as? String ?? ""
        
        return QuizQuestion(question: question, 
                            answers: answers,
                            correctAnswer: correctAnswerIndex,
                            correctAnswerDescription: correctAnswerDescription)
    }
    
    func getWordGameFromFirebase(activityName: String, completion: @escaping (WordGuessing?) -> Void) {
            let documentReference = db.collection("GAMES").document(activityName)
            documentReference.getDocument { (activityDocument, error) in
                if let error = error {
                    print("Error Getting Documents \(error)")
                    completion(nil)
                } else {
                    guard let actDoc = activityDocument, actDoc.exists else {
                        print("Document Does Not Exist")
                        completion(nil)
                        return
                    }
                    guard let data = actDoc.data() else {
                        completion(nil)
                        return
                    }
                    let title = data["title"] as? String ?? ""
                    let optionsStrings = data["options"] as? [String] ?? []
                    let options = optionsStrings.map { OptionTile(option: $0) } // Maps the strings to OptionTile instances and creates an array of OptionTiles
                    let answer = data["answer"] as? String ?? ""
                    let points = data["totalPoints"] as? Int ?? 0
                    let flipPoints = data["flipPoints"] as? Int ?? 0
                    let wordGuessing = WordGuessing(title: title,
                                                    options: options,
                                                    answer: answer,
                                                    totalPoints: points,
                                                    flipPoints: flipPoints,
                                                    flipsDone: 0,
                                                    numberOfGuesses: 0)
                completion(wordGuessing)
            }
        }
    }
    
    func getConnectionsFromFirebase(activityName: String, completion: @escaping (Connections?) -> Void) {
        let documentReference = db.collection("GAMES").document(activityName)
        documentReference.getDocument { (activityDocument, error) in
            if let error = error {
                print("Error Getting Documents \(error)")
                completion(nil)
            } else {
                guard let actDoc = activityDocument, actDoc.exists else {
                    print("Document Does Not Exist")
                    completion(nil)
                    return
                }
                guard let data = actDoc.data() else {
                    completion(nil)
                    return
                }
                
                let title = data["title"] as? String ?? ""
                let categories = data["categories"] as? [String] ?? []
                let answerKey = data["answerKey"] as? [String : [String]] ?? [:]
                let attempts = data["attempts"] as? Int ?? 0
                let points = data["points"] as? Int ?? 0
                
                let optionsStrings = data["options"] as? [String] ?? []
                let options = optionsStrings.enumerated().map { (index, content) in
                   return Connections.Option(id: "\(index + 1)", content: content, category: "") // You may need to provide a category here
               }
                
                let connections = Connections(title: title,
                                  categories: categories,
                                  answerKey: answerKey,
                                  options: options,
                                  selection: [],
                                  history: [],
                                  points: points,
                                  attempts: attempts,
                                  mistakes_remaining: 4,
                                  correct_categories: 0)
                completion(connections)
            }
        }
    }
}

