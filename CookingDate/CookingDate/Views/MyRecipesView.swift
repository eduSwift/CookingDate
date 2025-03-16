//
//  MyRecipesView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 05.03.25.
//

import SwiftUI

struct MyRecipesView: View {
    @State private var isAddingRecipe = false
    @State private var viewModel = RecipesViewModel()
    @Binding var selection: Int
    @Environment(SessionManager.self) var sessionManager  // 👈 Access the logged-in user

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("My Recipes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding()
                    Spacer()
                }

                if viewModel.recipes.isEmpty {
                    Text("No recipes yet")
                        .font(.title2)
                        .foregroundColor(.black.opacity(0.8))
                        .multilineTextAlignment(.center)
                } else {
                    List(viewModel.recipes) { recipe in
                        HStack(spacing: 15) {
                            RecipeImageView(imagePath: recipe.image)
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Text(recipe.name)
                                .font(.headline)
                        }
                        .padding(.vertical, 5)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .background(LinearGradient.appBackground.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isAddingRecipe = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundStyle(.black)
                    }
                }
            }
            .navigationDestination(isPresented: $isAddingRecipe) {
                AddRecipesView()
            }
            .onAppear {
                loadRecipes() // 👈 Load the correct user's recipes when the view appears
            }
            .onChange(of: sessionManager.currentUser?.id) {
                loadRecipes()
            }

        }
    }

    private func loadRecipes() {
          guard let userId = sessionManager.currentUser?.id else {
              viewModel.recipes = [] // No user logged in → Clear recipes
              return
          }
          viewModel.fetchUserRecipes(userId: userId) // ✅ Fetch only logged-in user's recipes
      }
  }

struct RecipeImageView: View {
    let imagePath: String
    
    var body: some View {
        if imagePath.hasPrefix("http") {
            AsyncImage(url: URL(string: imagePath)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                ProgressView()
            }
        } else {
            Image(imagePath)
                .resizable()
                .scaledToFill()
        }
    }
}


#Preview {
    MyRecipesView(selection: .constant(1))
}
