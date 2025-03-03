//
//  HomeView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 24.02.25.
//

import SwiftUI

struct HomeView: View {
    
    @State var viewModel = MealsViewModel()
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
    

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.appBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 20) {
                            Image("BFF")
                                .resizable()
                                .scaledToFill()
                                .padding(.vertical)
                            
                            SectionHeader(title: "Recently added")
                            RecipeRowMock(
                                itemWidth: itemWidth,
                                itemHeight: itemHeight,
                                recipes: Recipe.mockRecipes
                            )

                            SectionHeader(title: viewModel.searchText.isEmpty ? "Get inspired" : "Search Results")
                            
                            if viewModel.filteredRecipes.isEmpty {
                                Text(viewModel.searchText.isEmpty ? "No recipes available" : "No results found")
                                    .foregroundColor(.gray)
                                    .padding(.top, 10)
                                
                                ProgressView()
                            } else {
                                RecipeRowAPI(
                                    itemWidth: itemWidth,
                                    itemHeight: itemHeight,
                                    recipes: viewModel.filteredRecipes
                                )
                            }
                        }
                    }
                    .padding(.bottom, 60)
                }
                ZStack {
                    LinearGradient.appBackground
                        .ignoresSafeArea()
                }
                .frame(height: 50)
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search recipes...")
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


struct RecipeRowMock: View {
    let itemWidth: CGFloat
    let itemHeight: CGFloat
    let recipes: [Recipe]

    var body: some View {
        HStack(spacing: 10) {
            ForEach(recipes) { recipe in
                NavigationLink(destination: RecipeDetailsView(recipe: recipe)) {
                    VStack(alignment: .leading) {
                        Image(recipe.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: itemWidth, height: itemHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .clipped()

                        Text(recipe.name)
                            .lineLimit(1)
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .frame(width: itemWidth)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}


struct RecipeRowAPI: View {
    let itemWidth: CGFloat
    let itemHeight: CGFloat
    let recipes: [Meal]  
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(recipes, id: \.id) { meal in
                NavigationLink(destination: MealDetailsView(meal: meal)) {
                    VStack(alignment: .leading) {
                        AsyncImage(url: URL(string: meal.image)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: itemWidth, height: itemHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .clipped()
                        
                        Text(meal.name)
                            .lineLimit(1)
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .frame(width: itemWidth)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

#Preview {
    HomeView(selection: .constant(0))
}

