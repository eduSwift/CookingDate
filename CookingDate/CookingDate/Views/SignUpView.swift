//
//  SignUpView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 17.02.25.
//

import SwiftUI


struct SignUpView: View {
    
    @State var viewModel = SignUpViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Username")
                    .font(.system(size: 15))
                TextField("Username", text: $viewModel.username)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(AuthTextFieldStyle())
                Text("Email")
                    .font(.system(size: 15))
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(AuthTextFieldStyle())
                Text("Password")
                    .font(.system(size: 15))
                PasswordComponentView(showPassword: $viewModel.showPassword, password: $viewModel.password)
                Text("Confirm Password")
                    .font(.system(size: 15))
                PasswordComponentView(showPassword: $viewModel.showPassword, password: $viewModel.confirmPassword)
                
                Button(action: {
                    Task {
                        await  viewModel.signup()
                    }
                }, label: {
                    Text("Create account")
                        .font(.system(size: 15, weight: .semibold))
                        .padding(12)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                })
                HStack {
                    Spacer()
                    Text("Already have an account?")
                        .foregroundColor(.black)
                        .font(.system(size: 14))
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Login now")
                            .font(.system(size: 14, weight: .semibold))
                        
                    })
                    Spacer()
                }
                .padding(.top, 20)
                
            }
            
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient.appBackground)
            .ignoresSafeArea()
            if viewModel.isLoading {
                LoadingComponentView()
            }
           
        }
        .alert("Error", isPresented: $viewModel.presentAlert) {
            
        } message: {
            Text(viewModel.errorMessage)
        }
        
    }
        
}

#Preview {
    SignUpView()
}
