//
//  CookingDateApp.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 11.02.25.
//

import SwiftUI
import FirebaseCore

@main
struct CookingDateApp: App {
    @State var sessionManager: SessionManager
    
    init() {
        FirebaseApp.configure()
        
    
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "CardBackground")
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(Color("PrimaryText")),
            .font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        sessionManager = SessionManager()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch sessionManager.sessionState {
                case .loggedIn:
                    MainTabView()
                case .loggedOut:
                    LoginView()
                }
            }
            .environment(sessionManager)
            .preferredColorScheme(sessionManager.isDarkMode ? .dark : .light)
        }
    }
}
