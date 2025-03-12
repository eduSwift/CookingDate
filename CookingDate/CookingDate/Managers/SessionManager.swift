//
//  SessionManager.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 26.02.25.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

@Observable
class SessionManager {
    
    var sessionState: SessionState = .loggedOut
    var currentUser: User?
    var hasProfile = false
    
    init() {
        self.sessionState = Auth.auth().currentUser != nil ? .loggedIn : .loggedOut
        checkUserProfile()
        
    }
    
    func checkUserProfile() {
        guard let userId = Auth.auth().currentUser?.uid else {
            hasProfile = false
            return
        }
        
        Firestore.firestore().collection("userProfiles").document(userId).getDocument { snapshot, error in
                    if let error = error {
                        print("Error checking profile: \(error.localizedDescription)")
                        self.hasProfile = false
                        return
                    }
                    self.hasProfile = snapshot?.exists ?? false
                }
    }
    
    func signOut() {
         do {
             try Auth.auth().signOut()
             currentUser = nil
             sessionState = .loggedOut
         } catch {
             print("Sign out error: \(error.localizedDescription)")
         }
     }
    
}
