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
    @State private var sessionManager: SessionManager?
    @State private var showLaunch = true

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
    }

    var body: some Scene {
        WindowGroup {
            if showLaunch {
                LaunchAnimationView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            showLaunch = false
                        }
                    }
            } else if let sessionManager {
                Group {
                    switch sessionManager.sessionState {
                    case .loggedIn:
                        MainTabView()
                            .environment(sessionManager)
                    case .loggedOut:
                        LoginView()
                    }
                }
                .environment(sessionManager)
                .preferredColorScheme(sessionManager.isDarkMode ? .dark : .light)
            } else {
                ProgressView("Loading...")
                    .onAppear {
                        sessionManager = SessionManager()
                    }
            }
        }
    }
}

