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
        sessionManager = .init()
    }
    
    var body: some Scene {
        WindowGroup {
            switch sessionManager.sessionState {
            case .loggedIn:
                MainTabView()
                    .environment(sessionManager)
            case .loggedOut:
                LoginView()
                    .environment(sessionManager)
            }
        }
    }
}
