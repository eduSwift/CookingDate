//
//  RecipeDetailsView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 03.03.25.
//

import SwiftUI
import FirebaseFirestore

struct RecipeDetailsView: View {
    
    let recipe: Recipe
    @State private var isLiked = false
    @State private var creatorProfile: UserProfile?
    
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
                                    // Start conversation
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
}

#Preview {
    RecipeDetailsView(recipe: Recipe(id: "1", image: "", name: "", description: "", difficulty: "", ingredients: "", time: 0, userId: ""))
}
