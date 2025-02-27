//
//  SessionManager.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 26.02.25.
//

import Foundation
import FirebaseAuth
import FirebaseCore

@Observable
class SessionManager {
    
    var sessionState: SessionState = .loggedOut
    var currentUser: User?
    
    
    init() {
        FirebaseApp.configure()
        sessionState = Auth.auth().currentUser != nil ? .loggedIn : .loggedOut
        
    }
    
}
