//
//  SignUpViewModel.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 20.02.25.
//

import Foundation


class SignUpViewModel: ObservableObject {
    
    @Published var username = ""
    @Published var email = ""
    @Published var showPassword = false
    @Published var password = ""
    
}
