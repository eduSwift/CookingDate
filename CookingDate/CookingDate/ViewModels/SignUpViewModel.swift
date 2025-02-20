//
//  SignUpViewModel.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 20.02.25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@Observable
class SignUpViewModel{
    
   var username = ""
   var email = ""
   var password = ""
   var showPassword = false
   
    func signup() async {
        do {
            let result =  try await  Auth.auth().createUser(withEmail: email, password: password)
            let userId = result.user.uid
            let userData: [String: Any] = [
                "username": username,
                "email": email
            ]
            try await Firestore.firestore().collection("users").document(userId).setData(userData)
        } catch {
            
        }
           
    }
}
