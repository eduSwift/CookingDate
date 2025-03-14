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
                    
                    if viewModel.recipes.isEmpty {
                        Text("No recipes yet")
                            .font(.title2)
                            .foregroundColor(.black.opacity(0.8))
                            .multilineTextAlignment(.center)
                    } else {
                        List(viewModel.recipes) { recipe in
                            Text(recipe.name)
                        }
                    }
                }
            }
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
                Task {
                    await viewModel.fetchRecipes()
                }
            }
        }
    }
}



#Preview {
    MyRecipesView(selection: .constant(1))
}
