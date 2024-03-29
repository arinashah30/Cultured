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
    
    /*
     ----------------------------------------------------------------------------------------------
     User authentication
     -----------------------------------------------------------------------------------------------
     */
    
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
                     "completedCountries": [],
                     "currentCountry": "",
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
    
    /*-------------------------------------------------------------------------------------------------*/
    
    
    
    /*
     ------------------------------------------------------------------------------------------------
     Managing data of countries
     -----------------------------------------------------------------------------------------------
     */
    
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
    
    func createNewCountry(countryName: String, lattitude: Double, longitude: Double) {
        let countryRef = db.collection("COUNTRIES").document(countryName)
        countryRef.setData(["population": 5000, "lattitude": lattitude, "longitude": longitude])
        
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
    
    /*-------------------------------------------------------------------------------------------------*/
    
    /*
     -----------------------------------------------------------------------------------------------
     Populate models
     -----------------------------------------------------------------------------------------------
     */
    
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
    
    func getWordGameFromFirebase(activityName: String, completion: @escaping (WordGuessing?) -> Void) {
        let documentReference = db.collection("GAMES").document(activityName)
        documentReference.getDocument { (activityDocument, error) in
            if let error = error {
                print("Error Getting Documents \(error)")
                completion(nil)
                return
            }
            
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
            let answer = data["answer"] as? String ?? ""
            let points = data["totalPoints"] as? Int ?? 0
            let flipPoints = data["flipPoints"] as? Int ?? 0
            
            //Get the Options Reference
            documentReference.collection("OPTIONS").getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting the Quiz Questions \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                var optionTileArray = [OptionTile]()
                for optionDocuments in querySnapshot!.documents {
                    let optionData = optionDocuments.data()
                    if let option = self.parseOptionTile(optionData) {
                        optionTileArray.append(option)
                    }
                }
                let wordGuessing = WordGuessing(title: title,
                                                options: optionTileArray,
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
            }
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
            let points = data["points"] as? Int ?? 0
            let attempts = data["attempts"] as? Int ?? 0
            let mistakesRemaining = data["mistakesRemaining"] as? Int ?? 0
            let correctCategories = data["correctCategories"] as? Int ?? 0
            
            //References for the three subcollections
            let optionsRef = documentReference.collection("OPTIONS")
            let selectionsRef = documentReference.collection("SELECTIONS")
            let historyRef = documentReference.collection("HISTORY")
            
            optionsRef.getDocuments { (optionsSnapshot, optionsError) in
                guard let optionsSnapshot = optionsSnapshot, optionsError == nil else {
                    print("Error fetching options: \(optionsError?.localizedDescription ?? "")")
                    completion(nil)
                    return
                }
                
                let options = optionsSnapshot.documents.compactMap { document -> Connections.Option? in
                    let data = document.data()
                    return self.parseOption(data)
                }
                
                selectionsRef.getDocuments { (selectionsSnapshot, selectionsError) in
                    guard let selectionsSnapshot = selectionsSnapshot, selectionsError == nil else {
                        print("Error fetching selections: \(selectionsError?.localizedDescription ?? "")")
                        completion(nil)
                        return
                    }
                    
                    let selections = selectionsSnapshot.documents.compactMap { document -> Connections.Option? in
                        let data = document.data()
                        return self.parseOption(data)
                    }
                    
                    // Retrieve history
                    historyRef.getDocuments { (historySnapshot, historyError) in
                        guard let historySnapshot = historySnapshot, historyError == nil else {
                            print("Error fetching history: \(historyError?.localizedDescription ?? "")")
                            completion(nil)
                            return
                        }
                        
                        let history = historySnapshot.documents.compactMap { document -> [Connections.Option]? in
                            let data = document.data()
                            let optionDataArray = data["options"] as? [[String: Any]] ?? []
                            return optionDataArray.compactMap { optionData in
                                return self.parseOption(optionData)
                            }
                        }
                        
                        let connections = Connections(title: title,
                                                      categories: categories,
                                                      answerKey: answerKey,
                                                      options: options,
                                                      selection: selections,
                                                      history: history,
                                                      points: points,
                                                      attempts: attempts,
                                                      mistakes_remaining: mistakesRemaining,
                                                      correct_categories: correctCategories)
                        
                        completion(connections)
                    }
                }
            }
        }
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
    
    /*-------------------------------------------------------------------------------------------------*/
    
    /*
     -----------------------------------------------------------------------------------------------
     Manage user data
     -----------------------------------------------------------------------------------------------
     */
    
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
    
    
    
    /*-------------------------------------------------------------------------------------------------*/
    
    
    /*
     -----------------------------------------------------------------------------------------------
     Manage user's ongoing/completed activities
     -----------------------------------------------------------------------------------------------
     */
    
    func addOnGoingActivity(userID: String, country: String, titleOfActivity: String, typeOfActivity: String) {
        db.collection("USERS").document(userID).collection("ACTIVITIES").document("\(country)\(titleOfActivity)").setData(
            ["completed": false,
             
             "current": "",
             
             "history": [],
             
             "score": 0,
             
             "type": typeOfActivity, //MUST be "quiz", "connection", or "wordgame"
            ])
    }
    
    func getOnGoingActivity(userId: String, type: String, completion: @escaping([String]) -> Void) {
        db.collection("USERS").document(userId).collection("ACTIVITIES").whereField("type", isEqualTo: type).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error Getting Documents \(error)")
                completion([])
            } else {
                var activityArray = [String]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let completed = data["completed"] as? Bool ?? false
                    if !completed {
                        let nameOfActivity = document.documentID
                        activityArray.append(nameOfActivity)
                    }
                }
                
                completion(activityArray)
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
    
    func setCurrentCountry(userID: String, countryName: String, completion: @escaping (Bool) -> Void) {
        let countryNameUppercased = countryName.uppercased()
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
            self.db.collection("USERS").document(userID).updateData([
                    "currentCountry": countryNameUppercased
                ]) { err in
                    if let err = error {
                        print(err.localizedDescription)
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            
        }
    }
    
    /*-------------------------------------------------------------------------------------------------*/
    
    /*
     -----------------------------------------------------------------------------------------------
     Populate firebase activities
     -----------------------------------------------------------------------------------------------
     */
    
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
    
    
    func addOnGoingActivity(userID: String, numQuestions: Int, titleOfActivity: String, typeOfActivity: String, completion: @escaping (Bool) -> Void) {
        db.collection("USERS").document(userID).collection("ACTIVITIES").document("Wassup").setData(
            ["completed": false,
             
             "current": 0,
             
             "history": [],
             
             "score": 0,
             
             "numberOfQuestions": numQuestions,
             
             "type": typeOfActivity, //MUST be "quiz", "connection", or "wordgame"
            ])
        completion(true)
    }
    
    func createNewConnections(connection: Connections) {
        
        let connectionsReference = db.collection("GAMES").document(connection.title)
        
        connectionsReference.setData(
            ["title": connection.title,
             "categories": connection.categories,
             "answerKey": connection.answerKey,
             "points": connection.points,
             "attempts": connection.attempts,
             "mistakesRemaining": connection.mistakes_remaining,
             "correctCategories": connection.correct_categories
            ]) { error in
                if let error = error {
                    print("Error writing game document: \(error.localizedDescription)")
                } else {
                    print("Game document successfully written")
                }
            }
        
        //private(set) var options: [Option]
        let optionArray = connection.options //[Option]
        let optionArrayReference = connectionsReference.collection("OPTIONS")
        for option in optionArray {
            optionArrayReference.document(option.id).setData(
                ["id": option.id,
                 "isSelected": option.isSelected,
                 "isSubmitted": option.isSubmitted,
                 "content": option.content,
                 "category": option.category
                ])
        }
        
        //var selection: [Option]
        let optionSelectionArray = connection.selection //[Option]
        let optionSelectionArrayReference = connectionsReference.collection("SELECTIONS")
        for option in optionSelectionArray {
            optionSelectionArrayReference.document(option.id).setData(
                ["id": option.id,
                 "isSelected": option.isSelected,
                 "isSubmitted": option.isSubmitted,
                 "content": option.content,
                 "category": option.category
                ])
        }
        
        //var history: [[Option]]
        let historyArrayOfArrays = connection.history //[[Option]]
        let historyReference = connectionsReference.collection("HISTORY")
        for (index, options) in historyArrayOfArrays.enumerated() {
            let optionDictionaryArray = options.map {optionToDictionary(option: $0)}
            let documentData: [String: Any] = ["options": optionDictionaryArray]
            historyReference.document("History\(index)").setData(documentData)
        }
    }
    
    
    func createNewWordGuessing(wordGuessing: WordGuessing) {
        
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
        
    }
    
    /*-------------------------------------------------------------------------------------------------*/
    
    /*
     -----------------------------------------------------------------------------------------------
     Helper methods
     -----------------------------------------------------------------------------------------------
     */
    
    func optionToDictionary(option: Connections.Option) -> [String: Any] {
        return [
            "id": option.id,
            "isSelected": option.isSelected,
            "isSubmitted": option.isSubmitted,
            "content": option.content,
            "category": option.category
        ]
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
    
    
    //Helper Function to Turn the data from Firebase into a Quiz Question
    func parseOptionTile(_ optionData: [String: Any]) -> OptionTile? {
        let option = optionData["option"] as? String ?? ""
        let isFlipped = optionData["isFlipped"] as? Bool ?? false
        return OptionTile(option: option,
                          isFlipped: isFlipped)
        
    }
    
    
    func parseOption(_ optionData: [String: Any]) -> Connections.Option? {
        let id = optionData["id"] as? String ?? ""
        let isSelected = optionData["isSelected"] as? Bool ?? false
        let isSubmitted = optionData["isSubmitted"] as? Bool ?? false
        let content = optionData["content"] as? String ?? ""
        let category = optionData["category"] as? String ?? ""
        return Connections.Option(id: id,
                                  isSelected: isSelected,
                                  isSubmitted: isSubmitted,
                                  content: content,
                                  category: category)
        
    }
    
    //Helper Function to Ensure the Leaderboard is properly sorted
    func isSorted(_ array: [(String, Int)]) -> Bool {
        if array.count == 0 {
            return true
        }
        
        for i in 0..<(array.count - 1) {
            if array[i].1 < array[i + 1].1 {
                return false
            }
        }
        return true
    }
    
    func getfieldsofOnGoingActivity(userId: String, activity: String, completion: @escaping([String: Any]?) -> Void) {
        db.collection("USERS").document(userId).collection("ACTIVITIES").document(activity).getDocument{ doc, error in
            if let err = error {
                print(err.localizedDescription)
                completion(nil)
                return
            } else {
                if let document = doc {
                    if let data = document.data() {
                        var dictionary = [String: Any]()
                        for (key, val) in data {
                            dictionary[key] = val
                        }
                        completion(dictionary)
                        return
                    }
                }
            }
        }
    }
    
    /*-------------------------------------------------------------------------------------------------*/
    
    /*
     -----------------------------------------------------------------------------------------------
     Miscellaneous
     -----------------------------------------------------------------------------------------------
     */
    
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


    func getImage(imageName: String, completion: @escaping (UIImage?) -> Void) {
        let storage = Storage.storage()
        let imageRef = storage.reference().child("images/\(imageName)")
        
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("An error occured when getting the image data")
                completion(nil)
            } else if let data = data, let image = UIImage(data: data) {
                completion(image)
                print("Should have successfully returned image")
            } else {
                completion(nil)
            }
        }
    }
    
    
    func getLatitudeLongitude(countryName: String, completion: @escaping ([String: Double]?) -> Void) {
        let countryRef = db.collection("COUNTRIES").document(countryName)
        countryRef.getDocument { (document, error) in
            if let error = error {
                // Handle the error case

                print("Error getting countries document: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let document = document, document.exists {
                // Get the data from the document
                let data = document.data()
                let latitude = data?["latitude"] as? Double
                let longitude = data?["longitude"] as? Double
                
                // Check if both latitude and longitude exist
                if let lat = latitude, let long = longitude {
                    // If both values are found, return them in the completion handler
                    completion(["latitude": lat, "longitude": long])
                } else {
                    // Handle the case where one or both values are missing
                    print("Error: Document data is not valid")
                    completion(nil)
                }
            } else {
                // Handle the case where the document does not exist
                print("We are in this area")
                print("Document does not exist")
                completion(nil)
            }
        }
    
    func getTopSongs(for country: Country, amount: Int) async -> [Song] {
        var result = [Song]()
        var playlist_uri: String
        
        switch (country.name) {
            // NOTE: no data for China
        case "FRANCE":
            playlist_uri = "37i9dQZEVXbIPWwFssbupI"
        case "INDIA":
            playlist_uri = "37i9dQZEVXbLZ52XmnySJg"
        case "MEXICO":
            playlist_uri = "37i9dQZEVXbO3qyFxbkOE1"
        case "NIGERIA":
            playlist_uri = "37i9dQZEVXbKY7jLzlJ11V"
        case "UAE":
            playlist_uri = "37i9dQZEVXbM4UZuIrvHvA"
        default:
            return []
        }
        
        let authURL = URL(string: "https://accounts.spotify.com/api/token")!
        var requestAuth = URLRequest(url: authURL)
        requestAuth.allHTTPHeaderFields = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        requestAuth.httpMethod = "POST"
        let clientID = "a7704f381d02423d978245c28c31419f"
        let clientSecret = "b5be23d3682d44668ff87ae55f6231e7"
        requestAuth.httpBody = Data("grant_type=client_credentials&client_id=\(clientID)&client_secret=\(clientSecret)".utf8)
        do {
            let (authData, _) = try await URLSession.shared.data(for: requestAuth)
            let response = try JSONDecoder().decode(SpotifyAccessTokenResponse.self, from: authData)
            
            let url = URL(string: "https://api.spotify.com/v1/playlists/\(playlist_uri)/tracks?market=US&limit=\(amount)")!
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = [
                "Authorization": "Bearer \(response.access_token)"
            ]
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                
                let wrapper = try JSONDecoder().decode(SpotifyPlaylistAPIResult.self, from: data)
                
                for song in wrapper.items {
                    let track = song.track
                    var artists = track.artists
                    let albumName = track.album.name
                    var albumImageURL: URL? = nil
                    if let lastImage = track.album.images.last {
                        albumImageURL = lastImage.url
                    }
                    let spotifyURL = URL(string: "http://open.spotify.com/track/\(track.uri.split(separator: ":")[2])")
                    var previewURL: URL? = nil
                    if let urlString = track.previewURL {
                        previewURL = URL(string: urlString)
                    }
                    
                    var i = 0
                    for artist in artists {
                        if (artist.popularity == nil || artist.images == nil) {
                            let urlArtist = URL(string: "https://api.spotify.com/v1/artists/\(artist.uri?.split(separator: ":")[2] ?? "")")!
                            var requestArtist = URLRequest(url: urlArtist)
                            requestArtist.allHTTPHeaderFields = [
                                "Authorization": "Bearer \(response.access_token)"
                            ]
                            do {
                                let (dataArtist, _) = try await URLSession.shared.data(for: requestArtist)
                                
                                let artistObject = try JSONDecoder().decode(SpotifyArtistObject.self, from: dataArtist)
                                artists[i] = artistObject
                            } catch let err {
                                print(err)
                            }
                        }
                        i += 1
                    }
                    
                    let artistsObjects = artists.map({Artist(artist: $0)})
                    
                    let songObject = Song(name: track.name, artists: artistsObjects, albumName: albumName, albumImageURL: albumImageURL, spotifyURL: spotifyURL, previewURL: previewURL)
                    result.append(songObject)
                }
                
                return result
            } catch let error {
                print(error)
                return []
            }
        } catch {
            return []
        }
    }
    
    func getTopArtists(songs: [Song], amount: Int) -> [Artist] {
        var artists = Set<Artist>()
        
        for song in songs {
            artists.formUnion(song.artists)
        }
        
        let result = Array(Array(artists).sorted(by: {$0.popularity ?? 0 > $1.popularity ?? 0}).prefix(amount))
        return result
    }
    
    func getMusicData(for country: Country, songCount: Int, artistCount: Int) async -> ([Song], [Artist]) {
        var quantity = songCount < 25 ? 25 : songCount
        
        let songs = await getTopSongs(for: country, amount: quantity)
        let artists = getTopArtists(songs: songs, amount: artistCount)
        
        let firstNSongs = Array(songs.prefix(songCount))
        
        return (firstNSongs, artists)
    }
    /*-------------------------------------------------------------------------------------------------*/
    
}

