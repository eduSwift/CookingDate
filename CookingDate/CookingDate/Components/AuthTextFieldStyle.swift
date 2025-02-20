//
//  AuthTextFieldStyle.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 19.02.25.
//

import Foundation
import SwiftUI


struct AuthTextFieldStyle: TextFieldStyle {
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack {
            configuration
                .font(.system(size: 14))
                .textInputAutocapitalization(.never)
            Rectangle()
                .frame(height: 1)
                .padding(.bottom, 15)
        }
    }
}
