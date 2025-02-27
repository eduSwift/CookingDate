//
//  HomeView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 24.02.25.
//

import SwiftUI

struct HomeView: View {
    
   
    @State var viewModel = ProfileViewModel()
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
                            
                            RecipeRow(
                                itemWidth: itemWidth,
                                itemHeight: itemHeight,
                                recipes: Array(Recipe.mockRecipes.prefix(3))
                            )
                            
                            SectionHeader(title: "Near you")
                            
                            RecipeRow(
                                itemWidth: itemWidth,
                                itemHeight: itemHeight,
                                recipes: Array(Recipe.mockRecipes.suffix(3))
                            )
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
        }
        .searchable(text: $searchText)
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
        HStack(spacing: 10) {
            ForEach(recipes) { recipe in
                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
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


#Preview {
    HomeView(selection: .constant(0))
}
