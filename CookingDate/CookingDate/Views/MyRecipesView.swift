//
//  MyRecipesView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 05.03.25.
//

import SwiftUI

struct MyRecipesView: View {
    @State private var isAddingRecipe = false
    @Binding var viewModel: RecipesViewModel
    @Binding var selection: Int
    @Environment(SessionManager.self) var sessionManager
    

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.appBackground.ignoresSafeArea()

                VStack {
                    HStack {
                        Text("My Recipes")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding()
                        Spacer()
                    }

                    if viewModel.userRecipes.isEmpty {
                        Spacer()
                        Text("No recipes yet")
                            .font(.title2)
                            .foregroundColor(.black.opacity(0.8))
                            .multilineTextAlignment(.center)
                        Spacer()
                    } else {
                        List {
                            ForEach(viewModel.userRecipes) { recipe in
                                HStack(spacing: 15) {
                                    RecipeImageView(imagePath: recipe.image)
                                        .frame(width: 80, height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    Text(recipe.name)
                                        .font(.headline)
                                }
                                .padding(.vertical, 5)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        viewModel.deleteRecipe(recipe)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }

                                    Button {
                                        viewModel.recipeToEdit = recipe
                                        viewModel.isEditingRecipe = true
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(.blue)
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isAddingRecipe = true
                        } label: {
                            Image(systemName: "plus")
                                .foregroundStyle(.black)
                        }
                    }
                }
                .navigationDestination(isPresented: $isAddingRecipe) {
                    AddRecipesView()
                }
                .sheet(isPresented: $viewModel.isEditingRecipe) {
                    if let recipe = viewModel.recipeToEdit {
                        EditRecipeView(recipe: recipe)
                    }
                }
                .onAppear {
                    loadRecipes()
                }
                .onChange(of: sessionManager.currentUser?.id) {
                    loadRecipes()
                }
            }
        }
    }

    private func loadRecipes() {
        guard let userId = sessionManager.currentUser?.id else {
            viewModel.userRecipes = []
            return
        }
        viewModel.fetchUserRecipes(userId: userId)
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
    MyRecipesView(viewModel: .constant(.init()), selection: .constant(2))
}
