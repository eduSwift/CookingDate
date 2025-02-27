//
//  ProfileView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 26.02.25.
//

import SwiftUI

struct ProfileView: View {
    @State var viewModel = ProfileViewModel()
    @Environment(SessionManager.self) var sessionManager: SessionManager
    @Binding var selection: Int
    
    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
            
            VStack {
                Text("Under Construction")
                    .font(.largeTitle)
                    .bold()
                
                Button(action: {
                    viewModel.showSignOutAlert = true
                }, label: {
                    Text("Log Out")
                        .font(.system(size: 15, weight: .semibold))
                        .padding(12)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal)
                })
            }
            .alert("Are you sure you would like to log out?",
                   isPresented: $viewModel.showSignOutAlert) {
                Button("Log Out", role: .destructive) {
                    if viewModel.signOut() {
                        sessionManager.sessionState = .loggedOut
                    }
                    
                }
                Button("Cancel", role: .cancel) {}
            }
        }
        
    }
    
}

#Preview {
    ProfileView(selection: .constant(3))
        .environment(SessionManager())
}
