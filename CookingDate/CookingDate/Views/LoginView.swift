//
//  LoginView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 14.02.25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    
    
    
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
                    if viewModel.showPassword {
                        TextField("Passwrod", text: $viewModel.password)
                            .textFieldStyle(AuthTextFieldStyle())
                            .overlay(alignment: .trailing) {
                                Button(action: {
                                    viewModel.showPassword = false
                                }, label: {
                                    Image(systemName: "eye")
                                        .foregroundStyle(.black)
                                        .padding(.bottom)
                                })
                            }
                    } else {
                        VStack {
                            SecureField("Password", text: $viewModel.password)
                                .font(.system(size: 14))
                            Rectangle()
                                .frame(height: 1)
                                .padding(.bottom, 15)
                        }
                            .overlay(alignment: .trailing) {
                                Button(action: {
                                    viewModel.showPassword = true
                                }, label: {
                                    Image(systemName: "eye.slash")
                                        .foregroundStyle(.black)
                                        .padding(.bottom)
                                })
                            }
                        
                    }
                   
                    Button(action: {
                        Task {
                            print("user logged in")
                        }
                    }) {
                        Text("Login")
                            .font(.system(size: 15, weight: .semibold))
                            .padding(12)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        Task {
                            print("be my guest")
                        }
                    }) {
                        Text("Login as Guest")
                            .font(.system(size: 15, weight: .semibold))
                            .padding(12)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(.horizontal)
                    
                    
                    Text("Don't have an account?")
                        .foregroundColor(.black)
                        .font(.custom("SpaceGrotesk-Medium", size: 16))
                    Button(action: {
                        viewModel.presentSignUpView = true
                    }, label: {
                        Text("Sign up here")
                            .font(.custom("SpaceGrotesk-Medium", size: 16))
                        
                    })
                    
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
