//
//  HomeView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 24.02.25.
//

import SwiftUI

struct HomeView: View {
    @State var viewModel = HomeViewModel()
    @State var searchText = ""
    
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
                    TextField("Search recipes...", text: $searchText)
                        .padding(.leading, 30)
                        .padding(10)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .overlay(
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 15)
                                Spacer()
                            }
                        )
                        .padding(.horizontal)
                        .padding(.top)
                    
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
                                images: ["Risotto", "Burrito", "Carbo"],
                                titles: ["Risotto by", "Burrito by", "Carbonara by"]
                            )
                            
                            SectionHeader(title: "Near you")
                            
                            RecipeRow(
                                itemWidth: itemWidth,
                                itemHeight: itemHeight,
                                images: ["Quinoa", "Tiramisu", "Lasagna"],
                                titles: ["Quinoa Bowl by", "Tiramisu by", "Lasagna by"]
                            )
                        }
                        .padding(.bottom, 60)
                    }
                    
                    
                    ZStack {
                        LinearGradient.appBackground
                            .ignoresSafeArea()
                        TabView {
                            Color.clear
                                .tabItem { Label("Home", systemImage: "house") }
                            
                            Color.clear
                                .tabItem { Label("Recipes", systemImage: "book") }
                            
                            Color.clear
                                .tabItem { Label("Messages", systemImage: "message") }
                            
                            Color.clear
                                .tabItem { Label("Profile", systemImage: "person.circle") }
                        }
                        .background(LinearGradient.appBackground.ignoresSafeArea())
                    }
                    .frame(height: 50)
                }
            }
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
    let images: [String]
    let titles: [String]
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<3, id: \.self) { index in
                NavigationLink(destination: RecipeDetailView(imageName: images[index], title: titles[index])) {
                    VStack(alignment: .leading) {
                        Image(images[index])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: itemWidth, height: itemHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .clipped()
                        
                        Text(titles[index])
                            .lineLimit(1)
                            .font(.system(size: 13, weight: .semibold)) // Smaller font for balance
                    }
                    .frame(width: itemWidth)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading) // Align rows to the left
        .padding(.horizontal)
    }
}


#Preview {
    HomeView()
}
