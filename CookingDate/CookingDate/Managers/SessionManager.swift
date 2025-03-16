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
    
    var isDarkMode = false
    var sessionState: SessionState = .loggedOut
    var currentUser: User?
    var hasProfile = false
    
    
    init() {
           // Check if a user is already logged in
           if let user = Auth.auth().currentUser {
               self.currentUser = User(id: user.uid, username: user.displayName ?? "Unknown", email: user.email ?? "No Email")
           }
           
           // Listen for any authentication state changes
           Auth.auth().addStateDidChangeListener { _, user in
               if let user = user {
                   self.currentUser = User(id: user.uid, username: user.displayName ?? "Unknown", email: user.email ?? "No Email")
               } else {
                   self.currentUser = nil
               }
           }
       }
    
    /*init() {
        self.sessionState = Auth.auth().currentUser != nil ? .loggedIn : .loggedOut
        checkUserProfile()
        
    }
    
    init() {
        if let firebaseUser = Auth.auth().currentUser {
            self.sessionState = .loggedIn
            fetchCurrentUser(uid: firebaseUser.uid) // Fetch user from Firestore
        } else {
            self.sessionState = .loggedOut
        }
    }*/

    func fetchCurrentUser(uid: String) {
        let db = Firestore.firestore()
        db.collection("userProfiles").document(uid).getDocument { snapshot, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Error fetching user: \(error.localizedDescription)")
                    return
                }
                
                guard let data = snapshot?.data(),
                      let username = data["username"] as? String,
                      let email = data["email"] as? String else {
                    print("❌ User data is incomplete!")
                    return
                }
                
                self.currentUser = User(id: uid, username: username, email: email)
                print("✅ User loaded: \(self.currentUser?.username ?? "Unknown")")
                
                self.checkUserProfile()
            }
        }
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
            print("✅ User signed out")
        } catch {
            print("❌ Sign out error: \(error.localizedDescription)")
        }
    }

    
    /*func signOut() {
        do {
            try Auth.auth().signOut()
            currentUser = nil
            sessionState = .loggedOut
        } catch {
            print("Sign out error: \(error.localizedDescription)")
        }
    }*/
    
}
