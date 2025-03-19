//
//  MainTabView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 26.02.25.

import SwiftUI
import FirebaseFirestore

struct MainTabView: View {
    
    @State private var selectedTab = 0
    @State private var unreadCount = 0
    @AppStorage("lastChatCheck") var lastChatCheck: Double = 0
    @Environment(SessionManager.self) var sessionManager
    @State var recipesViewModel = RecipesViewModel()
    

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(recipesViewModel: $recipesViewModel, selection: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            MyRecipesView(viewModel: $recipesViewModel, selection: $selectedTab)
                .tabItem {
                    Label("My Recipes", systemImage: "book")
                }
                .tag(1)

            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "message")
                        .badge(unreadCount)
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
                       startChatListener()
                   }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    func startChatListener() {
            guard let userId = sessionManager.currentUser?.id else { return }

            Firestore.firestore().collection("chats")
                .whereField("userIds", arrayContains: userId)
                .addSnapshotListener { snapshot, error in
                    guard let docs = snapshot?.documents else { return }
                    let chats = docs.compactMap { try? $0.data(as: Chat.self) }

                    let lastCheck = Date(timeIntervalSince1970: lastChatCheck)
                    let newUnread = chats.filter { $0.timestamp > lastCheck }

                    self.unreadCount = newUnread.count
                }
        }
    
}

#Preview {
    MainTabView()
}
