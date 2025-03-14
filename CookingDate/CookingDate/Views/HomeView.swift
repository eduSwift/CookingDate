//
//  HomeView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 24.02.25.
//

import SwiftUI

struct HomeView: View {
    @State var viewModel = MealsViewModel()
    @State var viewModel2 = RecipesViewModel()
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
    
    enum RecipeMealItem: Identifiable {
        case recipe(Recipe)
        case meal(Meal)
        
        var id: String {
            switch self {
            case .recipe(let recipe): return recipe.id
            case .meal(let meal): return meal.id
            }
        }
    }
    
    var recentlyAddedRecipes: [Recipe] {
        return viewModel2.recipes
    }
    
    var combinedFilteredRecipes: [RecipeMealItem] {
        let mockResults = searchText.isEmpty ? recentlyAddedRecipes : recentlyAddedRecipes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        let mealResults = searchText.isEmpty ? viewModel.meals : viewModel.filteredMeals
        
        return mockResults.map { RecipeMealItem.recipe($0) } + mealResults.map { RecipeMealItem.meal($0) }
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
                        
                        if !searchText.isEmpty {
                            SectionHeader(title: "Search Results")
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(combinedFilteredRecipes) { item in
                                        switch item {
                                        case .recipe(let recipe):
                                            NavigationLink(destination: RecipeDetailsView(recipe: recipe)) {
                                                RecipeCard(recipe: recipe, itemWidth: itemWidth, itemHeight: itemHeight)
                                            }
                                        case .meal(let meal):
                                            NavigationLink(destination: MealDetailsView(meal: meal)) {
                                                RecipeCardAPI(meal: meal, itemWidth: itemWidth, itemHeight: itemHeight)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        } else {
                      
                           
                                SectionHeader(title: "Recently Added")
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(viewModel2.recipes) { recipe in
                                            NavigationLink(destination: RecipeDetailsView(recipe: recipe)) {
                                                RecipeCard(recipe: recipe, itemWidth: itemWidth, itemHeight: itemHeight)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            

                         
                            if !viewModel.meals.isEmpty {
                                SectionHeader(title: "Get Inspired")
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(viewModel.meals) { meal in
                                            NavigationLink(destination: MealDetailsView(meal: meal)) {
                                                RecipeCardAPI(meal: meal, itemWidth: itemWidth, itemHeight: itemHeight)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 60)
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search recipes...")
        
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

struct RecipeCard: View {
    let recipe: Recipe
    let itemWidth: CGFloat
    let itemHeight: CGFloat

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: recipe.image)) {
                image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: itemWidth, height: itemHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } placeholder: {
                VStack {
                    ProgressComponentView(value: .constant(0.5))
                }
            }
            Text(recipe.name)
                .lineLimit(1)
                .font(.system(size: 13, weight: .semibold))
        }
        .frame(width: itemWidth)
    }
}

struct RecipeCardAPI: View {
    let meal: Meal
    let itemWidth: CGFloat
    let itemHeight: CGFloat

    var body: some View {
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

#Preview {
    HomeView(selection: .constant(0))
}
