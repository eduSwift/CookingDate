//
//  LoginView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 14.02.25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
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
                
                VStack(spacing: 15) {
                    CustomTextField(icon: "envelope", placeholder: "Email", text: $email)
                    CustomSecureField(icon: "lock", placeholder: "Password", text: $password)
                }
                Button(action: {
                    Task {
                        print("user logged in")
                    }
                }) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .font(.custom("SpaceGrotesk-Bold", size: 18))
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Button(action: {
                    Task {
                        print("be my guest")
                    }
                }) {
                    Text("Login as Guest")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .font(.custom("SpaceGrotesk-Bold", size: 18))
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                NavigationLink("Don't have an account? Sign up here.", value: "signup")
                    .foregroundColor(.black)
                    .font(.custom("SpaceGrotesk-Medium", size: 16))
            }
            .padding()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient.appBackground)
        .ignoresSafeArea()
    }
}

struct CustomTextField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color.black.opacity(0.2))
                .cornerRadius(10)
            
            TextField(placeholder, text: $text)
                .foregroundColor(.white)
                .autocapitalization(.none)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

struct CustomSecureField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color.black.opacity(0.2))
                .cornerRadius(10)

            SecureField(placeholder, text: $text)
                .foregroundColor(.white)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

#Preview {
    LoginView()
}
