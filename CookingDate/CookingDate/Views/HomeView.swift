//
//  HomeView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 24.02.25.
//

import SwiftUI

struct HomeView: View {
    @State var viewModel = MealsViewModel()
    @State var searchText = ""
    @Binding var selection: Int
    
    let spacing: CGFloat = 10
    let padding: CGFloat = 5
    
    var itemWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return (screenWidth - (spacing * 2) - (padding * 2)) / 3
    }
    
    var itemHeight: CGFloat {
        return itemWidth * 1.2
    }
    
    var filteredMockRecipes: [Recipe] {
        searchText.isEmpty ? Recipe.mockRecipes : Recipe.mockRecipes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var filteredMeals: [Meal] {
        searchText.isEmpty ? viewModel.meals : viewModel.filteredRecipes
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.appBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Image("BFF")
                            .resizable()
                            .scaledToFill()
                            .padding(.vertical)
                        
                        // Recently Added Section
                        if !filteredMockRecipes.isEmpty {
                            SectionHeader(title: "Recently added")
                            RecipeRow(
                                itemWidth: itemWidth,
                                itemHeight: itemHeight,
                                recipes: filteredMockRecipes
                            )
                        }
                        
                        // API Meals Section
                        if !filteredMeals.isEmpty {
                            SectionHeader(title: searchText.isEmpty ? "Get inspired" : "Search Results")
                            RecipeRowAPI(
                                itemWidth: itemWidth,
                                itemHeight: itemHeight,
                                meals: filteredMeals
                            )
                        } else {
                            Text(searchText.isEmpty ? "No recipes available" : "No results found")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.bottom, 60)
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search recipes...")
        .onAppear {
            viewModel.loadRecipes()
        }
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title2.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
}

struct RecipeRow: View {
    let itemWidth: CGFloat
    let itemHeight: CGFloat
    let recipes: [Recipe]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(recipes) { recipe in
                    NavigationLink(destination: RecipeDetailsView(recipe: recipe)) {
                        VStack(alignment: .leading) {
                            Image(recipe.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: itemWidth, height: itemHeight)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            Text(recipe.name)
                                .lineLimit(1)
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .frame(width: itemWidth)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct RecipeRowAPI: View {
    let itemWidth: CGFloat
    let itemHeight: CGFloat
    let meals: [Meal]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(meals) { meal in
                    NavigationLink(destination: MealDetailsView(meal: meal)) {
                        VStack(alignment: .leading) {
                            AsyncImage(url: URL(string: meal.image)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(width: itemWidth, height: itemHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            Text(meal.name)
                                .lineLimit(1)
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .frame(width: itemWidth)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}



#Preview {
    HomeView(selection: .constant(0))
}

