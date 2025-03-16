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
    var currentUser: User?              // ✅ Used for login
    var userProfile: UserProfile?       // ✅ Used for chat/profile features
    var hasProfile = false

    init() {
        if let user = Auth.auth().currentUser {
            self.currentUser = User(
                id: user.uid,
                username: user.displayName ?? "Unknown",
                email: user.email ?? "No Email"
            )
            self.loadUserProfile(uid: user.uid)
        }
        
        Auth.auth().addStateDidChangeListener { _, user in
            if let user = user {
                self.currentUser = User(
                    id: user.uid,
                    username: user.displayName ?? "Unknown",
                    email: user.email ?? "No Email"
                )
                self.loadUserProfile(uid: user.uid)
            } else {
                self.currentUser = nil
                self.userProfile = nil
            }
        }
    }
    
    func loadUserProfile(uid: String) {
        Firestore.firestore().collection("userProfiles").document(uid).getDocument { snapshot, error in
            if let doc = snapshot {
                self.userProfile = try? doc.data(as: UserProfile.self)
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
            userProfile = nil
            sessionState = .loggedOut
        } catch {
            print("Sign out error: \(error.localizedDescription)")
        }
    }
}
