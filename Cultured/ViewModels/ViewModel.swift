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
    let db = Firestore.firestore()
    let auth = Auth.auth()


    func fireBaseSignIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
            if let error = error{
                completion(false)
            }
            else {
                completion(true)
            }
            //doesn't handle the case where authResult is nil so write that in if needed
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
                //this shouldn't run because each user should have a badges field
                print("No badges field for user")
                completion(false)
            }
        }
    }
    
    func addCompletedQuiz(userID: String, quizID: String, completion: @escaping (Bool) -> Void) {
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
            
            //if we can access data["completedGames"] as a string array then continue
            if var quizzes = data["completedGames"] as? [String] {
                //add the quizID
                quizzes.append(quizID)
                //try to re-update data["completedGames"] with the quizzes array with new quiz added
                //not sure that we totally need the below line because we use updateData on quizzes...?
                data["completedGames"] = quizzes
                
                //update the firebase using the path through USERS -> userID -> completedGames
                db.collection("USERS").document(userID).updateData(["completedGames": quizzes]) { error in
                    if let err = error {
                        print(err.localizedDescription)
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
                
            } else {
                //this shouldn't run because each user should have a quizzes field
                print("no completedGames field for the user")
                completion(false)
            }
            
        }
    }

}
