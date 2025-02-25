//
//  AppState.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 25.02.25.
//

// AppState.swift

import Foundation
import FirebaseAuth

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            self?.isLoggedIn = user != nil
        }
    }
}
