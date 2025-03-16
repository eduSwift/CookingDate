//
//  RecipeDetailsView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 03.03.25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct RecipeDetailsView: View {
    
    let recipe: Recipe
    @State private var isLiked = false
    @State private var creatorProfile: UserProfile?
    @State private var isChatActive = false
    @State private var chatToOpen: Chat?
    
    @Environment(SessionManager.self) var sessionManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: recipe.image)) {
                    image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .clipped()
                } placeholder: {
                    ZStack {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(height: 250)
                        Image(systemName: "photo.fill")
                    }
                }
                HStack {
                    Button {
                        withAnimation(.spring()) {
                            isLiked.toggle()
                        }
                    } label: {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .imageScale(.large)
                            .foregroundStyle(.red)
                    }
                    .padding()
                    
                    Text(recipe.name)
                        .font(.system(size: 22, weight: .semibold))
                    Spacer()
                    Image(systemName: "clock.fill")
                        .font(.system(size: 15))
                    Text("\(recipe.time) mins")
                        .font(.system(size: 15))
                    
                }
                .padding(.top)
                .padding(.horizontal)
                Text(recipe.description)
                    .font(.system(size: 15))
                    .padding(.top, 10)
                    .padding(.horizontal)
                    .textFieldStyle(CapsuleTextFieldStyle())
                    .padding(.bottom, 20)
                
                Text("Difficulty")
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top, 20)
                Text(recipe.difficulty)
                    .font(.system(size: 15))
                    .padding(.horizontal)
                    .textFieldStyle(CapsuleTextFieldStyle())
                Spacer()
                
                
                VStack(alignment: .leading) {
                    Text("Ingredients")
                        .font(.headline)
                    
                    ForEach(recipe.ingredients, id: \.self) { ingredient in
                        HStack(alignment: .top) {
                            Text("•")
                            Text(ingredient)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Recipe Creator")
                        .font(.headline)
                        .padding(.bottom, 8)
                    
                    if let creatorProfile = creatorProfile {
                        VStack(alignment: .leading) {
                            HStack {
                                AsyncImage(url: URL(string: creatorProfile.profileImageURL)) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } else {
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .foregroundColor(.gray)
                                    }
                                }
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                
                                VStack(alignment: .leading) {
                                    Text(creatorProfile.username)
                                        .font(.headline)
                                    Text("Age: \(creatorProfile.age)")
                                        .font(.subheadline)
                                }
                                
                                Spacer()
                                
                                VStack {
                                    Text(creatorProfile.onlineStatus ? "Online" : "Offline")
                                        .foregroundColor(creatorProfile.onlineStatus ? .green : .red)
                                    Text(creatorProfile.canHost ? "Can Host" : "Can't Host")
                                        .foregroundColor(creatorProfile.canHost ? .green : .red)
                                }
                            }
                            
                            HStack {
                                Button("See full Profile") {
                                    // Navigation to full profile
                                }
                                .buttonStyle(.bordered)
                                
                                Button("Message") {
                                    print("📩 Message button tapped!")
                                    startConversation()
                                }
                                .buttonStyle(.borderedProminent)
                                
                            }
                        }
                        
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(15)
                        .shadow(radius: 3)
                    } else {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                
                Spacer()
            }
        }
        .navigationDestination(isPresented: $isChatActive) {
            if let chat = chatToOpen {
                ChatDetailView(chat: chat)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(LinearGradient.appBackground.ignoresSafeArea())
        .onAppear {
            fetchCreatorProfile()
        }
    }
    
    private func fetchCreatorProfile() {
        let db = Firestore.firestore()
        db.collection("userProfiles").document(recipe.userId).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching creator profile: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists else {
                print("Creator profile not found")
                return
            }
            
            do {
                creatorProfile = try snapshot.data(as: UserProfile.self)
            } catch {
                print("Error decoding creator profile: \(error.localizedDescription)")
            }
        }
    }
    
    private func startConversation() {
        guard let currentUser = sessionManager.currentUser else {
            print("❌ No logged-in user found!")
            return
        }
        
        let userId = currentUser.id
        print("✅ Starting conversation for user: \(userId) with recipe creator: \(recipe.userId)")
        
        
        let db = Firestore.firestore()
        let sortedUserIds = [userId, recipe.userId].sorted()
        
        db.collection("chats")
            .whereField("userIds", arrayContainsAny: [userId, recipe.userId])
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching existing chat: \(error.localizedDescription)")
                    return
                }
                
                
                if let existingChat = snapshot?.documents.first {
                    if let chat = try? existingChat.data(as: Chat.self) {
                        navigateToChat(chat)
                    }
                } else {
                    print("📌 No existing chat found, creating a new one...")
                    createNewChat(userId: userId, recipeUserId: recipe.userId)
                }
            }
    }
    
    private func createNewChat(userId: String, recipeUserId: String) {
        let sortedUserIds = [userId, recipeUserId].sorted()
        let db = Firestore.firestore()
        let newChat = Chat(
            userIds: [userId, recipeUserId],
            sortedUserIds: sortedUserIds,
            lastMessage: "",
            timestamp: Date()
        )
        
        do {
            let chatRef = try db.collection("chats").addDocument(from: newChat)
            navigateToChat(Chat(
                id: chatRef.documentID,
                userIds: newChat.userIds,
                sortedUserIds: sortedUserIds,
                lastMessage: "",
                timestamp: newChat.timestamp
            ))
        } catch {
            print("Error creating chat: \(error.localizedDescription)")
        }
    }
    
    
    
    private func navigateToChat(_ chat: Chat) {
        self.chatToOpen = chat
        self.isChatActive = true
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(rootView: ChatDetailView(chat: chat))
            window.makeKeyAndVisible()
        }
    }
}

#Preview {
    RecipeDetailsView(recipe: Recipe(id: "1", image: "", name: "", description: "", difficulty: "", ingredients: "", time: 0, userId: ""))
}
