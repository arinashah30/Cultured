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
    
    @Published var errorText: String? = nil
    
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
                     "points" : "0", //points is a string and we can cast it to an int when we use it
                     "badges" : [],
                     "bio" : "",
                     "friends" : [],
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
                        print(points)
                        guard let unwrappedPoints = points else {
                            print("points is nil!")
                            return
                        }
                        print(unwrappedPoints)
                        let totalPoints = unwrappedPoints + pointToAdd
                        let newPoints: [String: Any] = ["points": totalPoints]
                        db.collection("USERS").document(userID).updateData(newPoints)  { error in
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
    
}

//let db = Firestore.firestore()
//let auth = Auth.auth()

