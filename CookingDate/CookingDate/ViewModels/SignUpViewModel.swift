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
   var isLoading = false
   var errorMessage = ""
   var presentAlert = false
   
    func signup() async -> Bool {
        do {
            isLoading = true
            let result =  try await  Auth.auth().createUser(withEmail: email, password: password)
            let userId = result.user.uid
            let userData: [String: Any] = [
                "username": username,
                "email": email
            ]
            try await Firestore.firestore().collection("users").document(userId).setData(userData)
            isLoading = false
            return true
        } catch(let error) {
            errorMessage = "Login Failed"
            let errorCode = error._code
            if let authErrorCode = AuthErrorCode(rawValue: errorCode) {
                switch authErrorCode {
                case .emailAlreadyInUse:
                    errorMessage = "Email already in use"
                case .invalidEmail:
                errorMessage = "Invalid Email"
                default:
                  break
                }
            }
            isLoading = false
            presentAlert = true
            return false
        }
           
    }
}
