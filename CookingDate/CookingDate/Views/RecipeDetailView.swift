//
//  ReceipeDetailView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 25.02.25.
//

import SwiftUI

struct RecipeDetailView: View {
    
    let imageName: String
    let title: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
            
            Text(title)
                .font(.largeTitle)
                .bold()
                .padding()
            
            Spacer()
        }
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(LinearGradient.appBackground.ignoresSafeArea())
    }
}

#Preview {
    RecipeDetailView(imageName: "", title: "")
}
