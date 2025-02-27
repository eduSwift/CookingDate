//
//  HomeViewModel.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 24.02.25.
//

import Foundation
import FirebaseAuth

@Observable
class ProfileViewModel {
    
    var showSignOutAlert = false
    
    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }

}
