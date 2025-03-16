//
//  MainTabView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 26.02.25.

import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab = 0
    @Environment(SessionManager.self) var sessionManager

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selection: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            MyRecipesView(selection: $selectedTab)
                .tabItem {
                    Label("My Recipes", systemImage: "book")
                }
                .tag(1)

            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "message")
                }
                .tag(2)

            if sessionManager.hasProfile {
                           ProfileDashboardView(selection: $selectedTab)
                               .tabItem {
                                   Label("Profile", systemImage: "person.circle")
                               }
                               .tag(3)
                       } else {
                           CreateProfileView(selection: $selectedTab)
                               .tabItem {
                                   Label("Profile", systemImage: "person.circle")
                               }
                               .tag(3)
                       }
                   }
                   .onAppear {
                       sessionManager.checkUserProfile()
                   }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    MainTabView()
}
