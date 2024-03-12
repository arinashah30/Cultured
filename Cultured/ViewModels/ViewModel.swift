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
    
    init(current_user: User? = nil, errorText: String? = nil) {
        self.current_user = current_user
        self.errorText = errorText
        UserDefaults.standard.setValue(false, forKey: "log_Status")
    }
    
    func fireBaseSignIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
            if let error = error{
                    print(error.localizedDescription)
                    let firebaseError = AuthErrorCode.Code(rawValue: error._code)
                    switch firebaseError {
                    case .wrongPassword:
                        self.errorText = "Password incorrect"
                    case .userNotFound:
                        self.errorText = "User not found"
                    case .userDisabled:
                        self.errorText = "Your account has been disabled"
                    default:
                        self.errorText = "An error has occurred"
                }
                completion(false)
            }
            else {
                UserDefaults.standard.setValue(true, forKey: "log_Status")
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
    
    func firebase_email_password_sign_up_(email: String, password: String, username: String) {
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
                     "name" : username,
                     "profilePicture" : "https://static-00.iconduck.com/assets.00/person-crop-circle-icon-256x256-02mzjh1k.png", // default icon
                     "email" : email,
                     "points" : 0, //points is a string and we can cast it to an int when we use it
                     "badges" : [],
                     "streak" : 0,
                     "completedChallenges": [],
                     "savedArtists": []
                    ] as [String : Any]) { error in
                        if let error = error {
                            self.errorText = error.localizedDescription
                        } else {
                            self.setCurrentUser(userId: username) {
                                UserDefaults.standard.setValue(true, forKey: "log_Status")
                            }
                        }
                    }
            }
        }
    }
    
    func setCurrentUser(userId: String, completion: @escaping (() -> Void)) {
        db.collection("USERS").document(userId).getDocument (completion: { [weak self] document, error in
            if let error = error {
                print("SetCurrentUserError: \(error.localizedDescription)")
            } else if let document = document {
                self?.current_user = User(id: document.documentID,
                                          name: document["name"] as! String,
                                          profilePicture: document["profilePicture"] as! String,
                                          email: document["email"] as! String, 
                                          points: document["points"] as? Int ?? 0,
                                          streak: document["streak"] as? Int ?? 0,
                                          completedChallenges: document["completedChallenges"] as? [String] ?? [],
                                          badges: document["badges"] as? [String] ?? [],
                                          savedArtists: document["savedArtists"] as? [String] ?? []
                                          )
                completion()
            }
        })
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

    
    func updateLastLoggedOn(userID: String, completion: @escaping (Bool) -> Void) {
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let dateInFormat = dateFormatter.string(from: date)
        
        self.db.collection("USERS").document(userID).updateData(["lastLoggedOn": dateInFormat]) {err in
            if let err = err {
                print("Error updating document: \(err.localizedDescription)")
                completion(false)
            } else {
                // Document updated successfully
                completion(true)
            }
        }
        
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
    
    func checkIfStreakIsIntact(userID: String, completion: @escaping (Bool) -> Void) {
        self.db.collection("USERS").document(userID).getDocument { document, error in
            if let err = error {
                print(err.localizedDescription)
                completion(false)
                return
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
                if let doc = document {
                    if let data = doc.data(), let lastlogged = data["lastLoggedOn"] as? String {
                        print("Logged: \(lastlogged)")
                        guard let last_date = dateFormatter.date(from: lastlogged) else {
                            print("Error converting last logged-on date string to Date")
                            completion(false)
                            return
                        }
                        let curr_date = Date()
                        
                        let calendar = Calendar.current
                        let components = calendar.dateComponents([.day], from: last_date, to: curr_date)
                        
                        if let daysSinceLastLoggedOn = components.day {
                            if daysSinceLastLoggedOn > 1 {
                                self.db.collection("USERS").document(userID).updateData(["streak": 0]) { error in
                                    if let error = error {
                                        print("Error updating document: \(error)")
                                    } else {
                                        print("Document updated successfully")
                                        completion(false)
                                    }
                                }
                                return
                            } else if daysSinceLastLoggedOn == 1 {
                                self.db.collection("USERS").document(userID).updateData(["streak": FieldValue.increment(Int64(1))]) { error in
                                    if let error = error {
                                        print("Error updating document: \(error)")
                                    } else {
                                        print("Document updated successfully")
                                        completion(true)
                                    }
                                }
                                return
                            } else {
                                completion(true)
                                return
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func createNewWordGuessing(wordGuessing: WordGuessing) {
        db.collection("GAMES").document(wordGuessing.title).setData(
            ["title": wordGuessing.title,
             "options": wordGuessing.options,
             "answer": wordGuessing.answer,
             "totalPoints": wordGuessing.totalPoints,
             "flipPoints": wordGuessing.flipPoints,
            ])
    }
    
    func getLeaderBoardInfo(completion: @escaping([(String, Int)]?) -> Void) {
        let usersCollectionReference = db.collection("USERS")
        usersCollectionReference.whereField("points", isGreaterThan: 0).order(by: "points", descending: true).limit(to: 20).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting Documents \(error)")
                completion(nil)
            } else {
                var topUsers: [(String, Int)] = []
                print(topUsers.count)
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let id = data["id"] as? String ?? ""
                    let points = data["points"] as? Int ?? 0
                    
                    // Add the user ID and streak to the topUsers dictionary
                    topUsers.append((id, points))
                }
                completion(topUsers)
            }
        }
    }
    
    //Helper Function to Ensure the Leaderboard is properly sorted
    func isSorted(_ array: [(String, Int)]) -> Bool {
        for i in 0..<(array.count - 1) {
            if array[i].1 < array[i + 1].1 {
                return false
            }
        }
        return true
    }
    
}

