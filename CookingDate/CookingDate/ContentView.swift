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
                                }
                            }
                        }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(LinearGradient.appBackground)
        }
    }

#Preview {
    ContentView()
}


