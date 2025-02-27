//
//  ContentView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 11.02.25.
//

import SwiftUI

struct ContentView: View {
    let images = ["ST8", "GAY", "LESB", "BFF"]
    
    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 20) {
                        ForEach(images, id: \.self) { image in
                            Image(image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 300, height: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .scrollTransition { content, phase in
                                    content
                                        .scaleEffect(
                                            x: phase.isIdentity ? 1.0 : 0.8,
                                            y: phase.isIdentity
                                            ? 1.0 : 0.8
                                        )
                                        .offset(y: phase.isIdentity ? 0: 200)
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .contentMargins(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(LinearGradient.appBackground)
            }
            VStack {
                Image("HT")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 200)
                    .padding(.top,20)
                Spacer()
                
            }
        }
    }
}

#Preview {
    ContentView()
}


