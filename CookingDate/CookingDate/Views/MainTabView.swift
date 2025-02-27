//
//  MainTabView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 26.02.25.

import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab = 0

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

            ChatView(selection: $selectedTab)
                .tabItem {
                    Label("Chat", systemImage: "message")
                }
                .tag(2)

            ProfileView(selection: $selectedTab)
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
                .tag(3)
        }
    }
}

#Preview {
    MainTabView()
}
