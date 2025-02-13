//
//  ContentView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 11.02.25.
//

import SwiftUI

struct ContentView: View {
    let images = ["HT", "GY", "LB"]
    
    var body: some View {
        ScrollView(.horizontal){
            LazyHStack{
                ForEach(images, id: \.self){ image in
                    Image(image)
                        .containerRelativeFrame(.horizontal)
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
           
        }
        .contentMargins(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient.appBackground)
    }
}

#Preview {
    ContentView()
}


