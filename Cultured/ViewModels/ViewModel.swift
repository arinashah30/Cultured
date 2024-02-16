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
}

let db = Firestore.firestore()
let auth = Auth.auth()

func update_points(userID: String, pointToAdd: Int, completion: @escaping (Bool) -> Void) {
    db.collection("USERS").document(userID).getDocument { document, error in
        if let err = error {
            print(err.localizedDescription)
            return
        } else {
            if let doc = document {
                if let data = doc.data() {
                    let points = data["points"] as? Int
                    guard let unwrappedPoints = points else {
                        print("points is nil")
                        return
                    }
                    var totalPoints = unwrappedPoints + pointToAdd
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
