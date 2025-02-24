//
//  HomeView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 24.02.25.
//

import SwiftUI

struct HomeView: View {
    
    @State var viewModel = HomeViewModel()
    @State var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            Tab("Home", systemImage: "house", value: 0) {
                HomeView(selection: selection)
            }
            
            Tab("Recipes", systemImage: "book", value: 1) {
                
            }
            
            Tab("Messages", systemImage: "message", value: 2) {
                
            }
            
            Tab("Profile", systemImage: "person.circle", value: 3) {
                
            }
        }
    }
}

#Preview {
    HomeView()
}
