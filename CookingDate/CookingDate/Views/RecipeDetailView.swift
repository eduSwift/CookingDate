//
//  ReceipeDetailView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 25.02.25.
//

import SwiftUI

struct RecipeDetailView: View {
    
    @State private var isLiked = false
    let imageName: String
    let title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 250)
                .clipped()
            
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
                
                Text(title)
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                Spacer()
                Image(systemName: "clock.fill")
                    .font(.system(size: 15))
                Text("20 mins")
                    .font(.system(size: 15))
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(LinearGradient.appBackground.ignoresSafeArea())
        }
        
    }
}

#Preview {
    RecipeDetailView(imageName: "", title: "")
}
