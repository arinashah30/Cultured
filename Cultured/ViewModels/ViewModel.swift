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
        
        _ = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if let user = user {
                print("User Found")
                if let username = user.displayName {
                    print("Setting User: \(username)")
                    self?.setCurrentUser(userId: username) {
                        UserDefaults.standard.setValue(true, forKey: "log_Status")
                    }
                }
            } else {
                UserDefaults.standard.setValue(false, forKey: "log_Status")
            }
        }
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
                    print("Password Incorrect")
                case .userNotFound:
                    self.errorText = "User not found"
                    print("User not found")
                case .userDisabled:
                    self.errorText = "Your account has been disabled"
                    print("Your account has been disabled")
                default:
                    self.errorText = "An error has occurred"
                    print("An error has occurred")
                }
                completion(false)
            }
            else {
                UserDefaults.standard.setValue(true, forKey: "log_Status")
                self.updateLastLoggedOn(email: email) { success in
                    if success {
                        print("lastLoggedOn field updated successfully")
                    } else {
                        print("Failed to update lastLoggedOn field")
                    }
                }
                completion(true)
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
                let currentDate = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
                let currentDateString = dateFormatter.string(from: currentDate)
                
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = username
                changeRequest.commitChanges { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
                self.db.collection("USERS").document(username).setData(
                    ["id" : username,
                     "name" : username,
                     "profilePicture" : "https://static-00.iconduck.com/assets.00/person-crop-circle-icon-256x256-02mzjh1k.png", // default icon
                     "email" : email,
                     "points" : 0,
                     "badges" : [],
                     "streak" : 0,
                     "streakRecord" : 0,
                     "lastLoggedOn" : currentDateString,
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
    
    func firebase_sign_out() {
        do {
            try auth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
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
    
    func getInfoLandmarks(countryName: String, completion: @escaping (Landmarks) -> Void) {
            self.db.collection("COUNTRIES").document(countryName).collection("MODULES").document("LANDMARKS").getDocument { document, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(Landmarks())
                    return
                }
                guard let document = document, document.exists else {
                    print("Document Doesn't Exist")
                    completion(Landmarks())
                    return
                }

                guard let data = document.data(), !data.isEmpty else {
                    print("Data is Nil or Data is Empty")
                    completion(Landmarks())
                    return
                }

                var landmarkMap = [String : String]()
                landmarkMap = data["landmarks"] as? [String : String] ?? [:]
                let landmarkObject = Landmarks(landmarkMap: landmarkMap)
                completion(landmarkObject)
            }
        }

  func getInfoEtiquettes(countryName: String, completion: @escaping (Etiquette) -> Void) {
        self.db.collection("COUNTRIES").document(countryName).collection("MODULES").document("ETIQUETTE").getDocument { document, error in
            if let error = error {
                print(error.localizedDescription)
                completion(Etiquette())
                return
            }
            guard let document = document, document.exists else {
                print("Document Doesn't Exist")
                completion(Etiquette())
                return
            }
            
            guard let data = document.data(), !data.isEmpty else {
                print("Data is Nil or Data is Empty")
                completion(Etiquette())
                return
            }
            
            var etiquetteMap = [String : String]()
            etiquetteMap = data["etiquettes"] as? [String : String] ?? [:]
            let etiquetteObject = Etiquette(etiquetteMap: etiquetteMap)
            completion(etiquetteObject)
        }
    }
    
    func getInfoSports(countryName: String, completion: @escaping (Sports) -> Void) {
        self.db.collection("COUNTRIES").document(countryName).collection("MODULES").document("SPORTS").getDocument { document, error in
            if let error = error {
                print(error.localizedDescription)
                completion(Sports())
                return
            }
            guard let document = document, document.exists else {
                print("Document Doesn't Exist")
                completion(Sports())
                return
            }
            
            guard let data = document.data(), !data.isEmpty else {
                print("Data is Nil or Data is Empty")
                completion(Sports())
                return
            }
            
            let athletes = data["athletes"] as? [String] ?? []
//            var sportsDictionary = [String : String]()
            let sportsDictionary = data["sports"] as? [String : String] ?? [:]
            let sportsObject = Sports(athletes: athletes, sports: sportsDictionary)
            completion(sportsObject)
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
                                          streakRecord: document["streakRecord"] as? Int ?? 0,
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
            let options = data["hints"] as? [String] ?? []
            
            var optionTileArray = [OptionTile]()
            for option in options {
                optionTileArray.append(OptionTile(option: option,
                                                  isFlipped: false))
            }

            let wordGuessing = WordGuessing(title: title,
                                            options: optionTileArray,
                                            answer: answer)
            completion(wordGuessing)
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
            let answerKey = data["answerKey"] as? [String : [String]] ?? [:]
            let connections = Connections(title: title, answerKey: answerKey)
            completion(connections)
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
                        let question = questionsDocuments.documentID
                        if let quizQuestion = self.parseQuestionData(questionData, question) {
                            questionsArray.append(quizQuestion)
                        }
                    }
                    let quiz = Quiz(title: title,
                                    questions: questionsArray,
                                    points: 0,
                                    pointsGoal: 0,
                                    currentQuestion: 0)
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
    
    func updateLastLoggedOn(email: String, completion: @escaping(Bool) -> Void) {
        self.db.collection("USERS").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting document: \(error.localizedDescription)")
                completion(false)
            } else if let documents = querySnapshot?.documents, !documents.isEmpty {
                // Assuming email is unique, get the first document
                let userID = documents[0].documentID
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
                let dateInFormat = dateFormatter.string(from: date)
                
                // Update the lastLoggedOn field for the user
                self.db.collection("USERS").document(userID).updateData(["lastLoggedOn": dateInFormat]) { err in
                    if let err = err {
                        print("Error updating document: \(err.localizedDescription)")
                        completion(false)
                    } else {
                        // Document updated successfully
                        completion(true)
                    }
                }
            } else {
                // No document found with the given email
                print("No document found with the email: \(email)")
                completion(false)
            }
        }
    }
    
    //Return "true" if streak is incremented or stays same
    //Return "false" if streak is reset to 0
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
                            //Update Streak to 0 if more than 1 day passed since last login
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
                            // Increment Streak by 1 if last login was yesterday
                            } else if daysSinceLastLoggedOn == 1 {
                                self.db.collection("USERS").document(userID).updateData(["streak": FieldValue.increment(Int64(1))]) { error in
                                    if let error = error {
                                        print("Error updating document: \(error)")
                                    } else {
                                        print("Document updated successfully")
                                        completion(true)
                                        self.updateStreakRecord(userID: userID) { success in
                                            if success {
                                                print("Streak Record updated sucessfully")
                                            } else {
                                                print("Failed to update Streak Record")
                                            }
                                        }
                                    }
                                }
                                return
                            //Do nothing since last login was today
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
    
    //Returns "false" if current streak is less than or equal to the streakRecord
    //Returns "true" if current streak is greater than the streakRecord
    func updateStreakRecord(userID: String, completion: @escaping(Bool) -> Void) {
        let documentReference = db.collection("USERS").document(userID)

        documentReference.getDocument { (document, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let document = document, document.exists else {
                print("Document Doesn't Exist")
                completion(false)
                return
            }
            
            guard let data = document.data() else {
                print("Data Doesn't Exist")
                completion(false)
                return
            }
            
            let currentStreak = data["streak"] as? Int ?? 0
            let recordStreak = data["streakRecord"] as? Int ?? 0
            
            if currentStreak > recordStreak {
                documentReference.updateData(["streakRecord": currentStreak])
                completion(true)
                return
            }
            completion(false)
        }
    }

    func addCompletedCountry(userID: String, countryName: String, completion: @escaping (Bool) -> Void) {
        let countryName = countryName.uppercased()
        self.db.collection("USERS").document(userID).getDocument { document, error in
            if let err = error {
                print(err.localizedDescription)
                completion(false)
                return
            }
            guard let document = document, document.exists, var completedCountries = document.data()?["completedCountries"] as? [String] else {
                print("Document does not exist or 'completedCountries' is not an array.")
                completion(false)
                return
            }
            // Check if countryName is already in the array to avoid duplicates
            if !completedCountries.contains(countryName) {
                // Append the new countryName to the array
                completedCountries.append(countryName)
                // Update the document with the new array
                self.db.collection("USERS").document(userID).updateData(["completedCountries": completedCountries]) { err in
                    if let err = err {
                        print("Error updating document: \(err.localizedDescription)")
                        completion(false)
                    } else {
                        // Document updated successfully
                        completion(true)
                    }
                }
            } else {
                print("Country already completed.")
                completion(true)
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
     Manage user's ongoing/completed activities
     -----------------------------------------------------------------------------------------------
     */
    
    func addOnGoingActivity(userID: String, country: String, numQuestions: Int, titleOfActivity: String, typeOfActivity: String, completion: @escaping (Bool) -> Void) {
        db.collection("USERS").document(userID).collection("ACTIVITIES").document("\(country)\(titleOfActivity)").setData(
            ["completed": false,

             "current": 0,

             "history": [],

             "score": 0,

             "numberOfQuestions": numQuestions,

             "type": typeOfActivity, //MUST be "quiz", "connection", or "wordgame"
            ])
            completion(true)
        }
    
    func getOnGoingActivities(userId: String, type: String, completion: @escaping([String : [String : Any]]) -> Void) {
        db.collection("USERS").document(userId).collection("ACTIVITIES").whereField("type", isEqualTo: type).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error Getting Documents \(error)")
                completion([:])
            } else {
                var activityDictionary = [String : [String : Any]]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let completed = data["completed"] as? Bool ?? false
                    if !completed {
                        
                        let current = data["current"] as? Int ?? 0
                        let history = data["history"] as? [String] ?? []
                        let numberOfQuestions = data["numberOfQuestions"] as? Int ?? 0
                        let score = data["score"] as? Int ?? 0
                        let type = data["type"] as? String ?? ""
                        
                        var typeDictionary = [String : Any]()
                        typeDictionary["completed"] = completed
                        typeDictionary["current"] = current
                        typeDictionary["history"] = history
                        typeDictionary["numberOfQuestions"] = numberOfQuestions
                        typeDictionary["score"] = score
                        typeDictionary["type"] = type
                        
                        let nameOfActivity = document.documentID
                        activityDictionary[nameOfActivity] = typeDictionary
                    }
                }
                completion(activityDictionary)
            }
        }
    }
    
    func getAllCompletedActivities(userId: String, type: String, completion: @escaping([String : [String : Any]]) -> Void) {
            db.collection("USERS").document(userId).collection("ACTIVITIES").whereField("type", isEqualTo: type).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error Getting Documents \(error)")
                    completion([:])
                } else {
                    var activityDictionary = [String : [String : Any]]()
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let completed = data["completed"] as? Bool ?? false
                        if completed {
                            let current = data["current"] as? Int ?? 0
                            let history = data["history"] as? [String] ?? []
                            let numberOfQuestions = data["numberOfQuestions"] as? Int ?? 0
                            let score = data["score"] as? Int ?? 0
                            let type = data["type"] as? String ?? ""

                            var typeDictionary = [String : Any]()
                            typeDictionary["completed"] = completed
                            typeDictionary["current"] = current
                            typeDictionary["history"] = history
                            typeDictionary["numberOfQuestions"] = numberOfQuestions
                            typeDictionary["score"] = score
                            typeDictionary["type"] = type

                            let nameOfActivity = document.documentID
                            activityDictionary[nameOfActivity] = typeDictionary
                        }
                    }

                    completion(activityDictionary)
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
    
    //Function to incrementCurrent
    func incrementCurrent(userID: String, activityName: String, completion: @escaping (Bool) -> Void) {
        self.db.collection("USERS").document(userID).collection("ACTIVITIES").document(activityName).getDocument { document, error in
            if let err = error {
                print(err.localizedDescription)
                completion(false)
                return
            }
            guard let document = document, document.exists, var currentCounter = document.data()?["counter"] as? Int else {
                print("Document does not exist")
                completion(false)
                return
            }
            currentCounter = currentCounter + 1
            self.db.collection("USERS").document(userID).collection("ACTIVITIES").document(activityName).updateData(["counter": currentCounter]) { err in
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
    
    func checkIfOnGoingActivityIsCompleted(userID: String, activity: String, completion: @escaping (Bool) -> Void) {
        db.collection("USERS").document(userID).collection("ACTIVITIES").document(activity).getDocument { (document, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            guard let document = document, document.exists else {
                print("Document Doesn't Exist")
                completion(false)
                return
            }
            
            guard let data = document.data(), !data.isEmpty else {
                print("Data is Nil or Data is Empty")
                completion(false)
                return
            }
            
            let completed = data["completed"] as? Bool ?? false
            completion(completed)
        }

    }
    

    
    /*-------------------------------------------------------------------------------------------------*/
    
    /*
     -----------------------------------------------------------------------------------------------
     Populate firebase activities
     -----------------------------------------------------------------------------------------------
     */
    
    func createNewQuiz(quiz: Quiz) {
        db.collection("GAMES").document(quiz.title).setData(["title": quiz.title])
        let quizQuestions = quiz.questions
        let quizRef = db.collection("GAMES").document(quiz.title)
        for question in quizQuestions {
            quizRef.collection("QUESTIONS").document(question.question).setData(
                ["answerChoices": question.answers,
                 "correctAnswer": question.correctAnswer,
                 "correctAnswerDescription": question.correctAnswerDescription,
//                 "image", question.image,
                ])
        }
    }
    
    
    func addOnGoingActivity(userID: String, numQuestions: Int, titleOfActivity: String, typeOfActivity: String, completion: @escaping (Bool) -> Void) {
        db.collection("USERS").document(userID).collection("ACTIVITIES").document(titleOfActivity).setData(
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
             "answerKey": connection.answerKey
            ]) { error in
                if let error = error {
                    print("Error writing game document: \(error.localizedDescription)")
                } else {
                    print("Game document successfully written")
                }
            }
    }
    
    
    func createNewWordGuessing(wordGuessing: WordGuessing) {
        
        let optionsReference = db.collection("GAMES").document(wordGuessing.title)
       
        var winCount = [String : Int]()
        for i in 1..<10 {
            winCount["\(i)"] = 0 //initialize every win count to 0 for every hint number
        }
        let optionTileArray = wordGuessing.options //[OptionTile]
                var options = [String]()
                for optionTile in optionTileArray {
                    options.append(optionTile.option)
        }
        
        optionsReference.setData(
            ["title": wordGuessing.title,
             "answer": wordGuessing.answer,
             "winCount" : winCount,
             "hints" : options
            ]) { error in
                if let error = error {
                    print("Error writing game document: \(error.localizedDescription)")
                } else {
                    print("Game document successfully written")
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
    func parseQuestionData(_ questionData: [String: Any], _ question: String) -> QuizQuestion? {
        let answers = questionData["answerChoices"] as? [String] ?? []
        let correctAnswerIndex = questionData["correctAnswer"] as? Int ?? 0
        let correctAnswerDescription = questionData["correctAnswerDescription"] as? String ?? ""
//        let image = questionData["image"] as? String ?? ""
        
        return QuizQuestion(question: question,
                            answers: answers,
                            correctAnswer: correctAnswerIndex,
                            correctAnswerDescription: correctAnswerDescription)
//                            ,image: image)
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
    
    func getWinCountDictionary(nameOfWordgame: String, completion: @escaping([String : Int]) -> Void) {
        
        let wordgameReference = db.collection("GAMES").document(nameOfWordgame)
//        var winCount = [String : Int]()

        wordgameReference.getDocument() { (activityDocument, error) in
            if let error = error {
                print("Error Getting Documents \(error)")
                completion([:])
                return
            }
            
            guard let actDoc = activityDocument, actDoc.exists else {
                print("Document Does Not Exist")
                completion([:])
                return
            }
            
            guard let data = actDoc.data() else {
                return
            }
            
            let winCount = data["winCount"] as? [String : Int] ?? [:]
            completion(winCount)
        }
    }
    
    func updateWinCountDictionary(nameOfWordgame: String, hintCount: Int, completion: @escaping(Bool) -> Void) {
        let wordgameReference = db.collection("GAMES").document(nameOfWordgame)

        // Update the specific key in the map
        wordgameReference.updateData(["winCount.\(hintCount)": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                print("Error updating document: \(error)")
                completion(false)
            } else {
                print("Document successfully updated")
                completion(true)
            }
        }
    }
}
