//
//  MyRecipesView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 05.03.25.
//

import SwiftUI

struct MyRecipesView: View {
    @State private var isAddingRecipe = false
    @Binding var selection: Int
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.appBackground
                    .ignoresSafeArea()
                
                
                VStack {
                    HStack {
                        Text("My Recipes")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding()
                        Spacer()
                    }
                    
                    Spacer()
                    
    
                    Text("No recipes yet")
                        .font(.title2)
                        .foregroundColor(.black.opacity(0.8))
                        .multilineTextAlignment(.center)
                    
                    Spacer()
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
        }
    }
}



#Preview {
    MyRecipesView(selection: .constant(1))
}
