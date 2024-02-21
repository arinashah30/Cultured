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
}
