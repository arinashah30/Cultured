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
}
