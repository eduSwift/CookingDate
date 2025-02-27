//
//  MyRecipesView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 26.02.25.
//

import SwiftUI

struct MyRecipesView: View {
    
    @State var viewModel = MyRecipesViewModel()
    @Binding var selection: Int
    
    
    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("My Recipes")
                    .font(.system(size: 26, weight: .bold))
                    .padding(.top, 20)
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.primaryFormEntry)
                        .frame(height: 200)
                    Image(systemName: "photo.fill")
                }
                Text("Recipe Name")
                    .font(.system(size: 15, weight: . semibold))
                    .padding(.top)
                TextField("", text: $viewModel.recipeName)
                    .textFieldStyle(CapsuleTextFieldStyle())
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                Text("Preparation Time")
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.top)
                Picker(selection: $viewModel.preparationTime) {
                    ForEach(0...120, id: \.self) { time in
                        if time % 5 == 0 {
                            Text("\(time) mins")
                                .font(.system(size: 15))
                                .tag(time)
                        }
                    }
                } label: {
                    Text("Prep Time")
                }
                Text("Cooking Instructions")
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.top)
                TextEditor(text: $viewModel.description)
                    .frame(height: 150)
                    .background(Color.primaryFormEntry)
                    .scrollContentBackground(.hidden)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Button(action: {
                }, label: {
                    Text("Add Recipe")
                        .font(.system(size: 15, weight: .semibold))
                        .padding(12)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                })
                
                Spacer()
            }
            .padding(.horizontal)
            
        }
    }
}

#Preview {
    MyRecipesView(selection: .constant(1))
}
