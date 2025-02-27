//
//  LoginView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 14.02.25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @State var viewModel = LoginViewModel()
    @Environment(SessionManager.self) var sessionManager: SessionManager
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Image("HT")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                    .padding(.top,20)
                
                Text("Login")
                    .font(.largeTitle).bold()
                    .foregroundColor(.black)
                
                VStack(alignment: .leading) {
                    Text("Email")
                        .font(.system(size: 15))
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .textFieldStyle(AuthTextFieldStyle())
                    
                    Text("Password")
                        .font(.system(size: 15))
                    PasswordComponentView(showPassword: $viewModel.showPassword, password: $viewModel.password)
                    
                }
                
                Button(action: {
                    sessionManager.sessionState = .loggedIn
                }, label: {
                    Text("Login")
                        .font(.system(size: 15, weight: .semibold))
                        .padding(12)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                })
         
                Button(action: {
                    
                       }, label: {
                    Text("Login as Guest")
                        .font(.system(size: 15, weight: .semibold))
                        .padding(12)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                })
                HStack {
                    Spacer()
                    Text("Don't have an account?")
                        .foregroundColor(.black)
                        .font(.system(size: 14))
                    Button(action: {
                        viewModel.presentSignUpView = true
                    }, label: {
                        Text("Sign up here")
                            .font(.system(size: 14, weight: .semibold))
                        
                    })
                    Spacer()
                }
                .padding(.top, 20)
            }
            .padding()
            .fullScreenCover(isPresented: $viewModel.presentSignUpView, content: {
                SignUpView()
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient.appBackground)
            .ignoresSafeArea()
        }
    }
}


#Preview {
    LoginView()
}

struct AuthTextFieldView: View {
    
    @Binding var inputTextField: String
    
    var body: some View {
        VStack {
            TextField("Email", text: $inputTextField)
                .font(.system(size: 14))
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
            Rectangle()
                .frame(height: 1)
                .padding(.bottom, 15)
        }
    }
}




