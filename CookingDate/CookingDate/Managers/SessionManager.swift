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
            DispatchQueue.main.async {
                if let error = error {
                    print("Error checking profile: \(error.localizedDescription)")
                    self.hasProfile = false
                    return
                }
                let profileExists = snapshot?.exists ?? false
                if profileExists != self.hasProfile {  
                    self.hasProfile = profileExists
                    print("Profile status updated: \(profileExists)")
                }
            }
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
