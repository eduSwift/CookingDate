
//
//  ReceipeDetailView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 25.02.25.
//

import SwiftUI

struct MealDetailsView: View {
    
    let meal: Meal
    
    @State private var isLiked = false
   
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: meal.image)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .clipped()
                } else if phase.error != nil {
                    Text("Failed to load image")
                        .frame(height: 250)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.3))
                } else {
                    ProgressView()
                        .frame(height: 250)
                        .frame(maxWidth: .infinity)
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
                
                Text(meal.name)
                    .font(.system(size: 22, weight: .semibold))
                Spacer()
            }
            .padding(.top)
            .padding(.horizontal)
            
            Text(meal.description)
                .font(.system(size: 15))
                .padding(.top, 10)
                .padding(.horizontal)
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(LinearGradient.appBackground.ignoresSafeArea())
    }
}

#Preview {
    MealDetailsView(meal: Meal(id: "1234", name: "Pasta", image: "https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg", description: "Delicious homemade pasta."))
}
