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
        }
    }
}

