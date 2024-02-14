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

    func getPts(userID: String, completion: @escaping (Int) -> Void) {
        db.collection("USERS").document(userID).getDocument { document, error in
            if let err = error {
                print(err.localizedDescription)
                return
            } else {
                if let doc = document {
                    if let data = doc.data() {
                        let points = data["points"] as? Int
                        completion(points!)
                    }
                }
            }
        }
    }
    
    func getBadges(userID: String, completion: @escaping ([String]) -> Void) {
        db.collection("USERS").document(userID).getDocument { document, error in
            if let err = error {
                print(err.localizedDescription)
                return
            } else {
                if let doc = document {
                    if let data = doc.data() {
                        let badges = data["badges"] as? [String]
                        completion(badges!)
                    }
                }
            }
        }
    }
}



