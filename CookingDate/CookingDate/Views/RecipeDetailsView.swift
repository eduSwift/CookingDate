//
//  RecipeDetailsView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 03.03.25.
//

import SwiftUI

struct RecipeDetailsView: View {
    
    let recipe: Recipe
    
    @State private var isLiked = false
    
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
                Spacer()
                
                
                             
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(LinearGradient.appBackground.ignoresSafeArea())
    }
}
#Preview {
    RecipeDetailsView(recipe: Recipe(id: "1", image: "", name: "", description: "", difficulty: "", ingredients: "", time: 0, userId: ""))
}
