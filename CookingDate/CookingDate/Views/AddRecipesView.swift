//
//  MyRecipesView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 26.02.25.
//

import SwiftUI
import PhotosUI

struct AddRecipesView: View {
    
    @State var viewModel = AddRecipesViewModel()
    @StateObject var imageLoaderViewModel = ImageLoaderViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                ZStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.primaryFormEntry)
                            .frame(height: 200)
                        
                        Image(systemName: "photo.fill")
                    }
                    if let displayedRecipeImage = viewModel.displayedRecipeImage {
                        
                        displayedRecipeImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .clipped()
                    }
                }
                .onTapGesture {
                    viewModel.showImageOptions = true
                }
                
                Text("Recipe Name")
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.top)
                TextField("Enter recipe name", text: $viewModel.recipeName)
                    .textFieldStyle(CapsuleTextFieldStyle())
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
                Text("Preparation Time")
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.top)
                Picker(selection: $viewModel.preparationTime) {
                    ForEach(0...120, id: \.self) { time in
                        if time % 5 == 0 {
                            Text("\(time) mins").tag(time)
                        }
                    }
                } label: {
                    Text("Prep Time")
                }
                
                Text("Difficulty")
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.top)
                TextField("Enter difficulty level", text: $viewModel.difficulty)
                    .textFieldStyle(CapsuleTextFieldStyle())
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.words)
                
                Text("Ingredients")
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.top)
                TextEditor(text: $viewModel.ingredients)  
                    .frame(height: 150)
                    .background(Color.primaryFormEntry)
                    .scrollContentBackground(.hidden)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Spacer()
                
                Button(action: {
                    Task {
                        await viewModel.addRecipe()
                    }
                }, label: {
                    Text("Save Recipe")
                        .font(.system(size: 15, weight: .semibold))
                        .padding(12)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                })
            }
            .padding(.horizontal)
            .photosPicker(isPresented: $viewModel.showLibrary, selection: $imageLoaderViewModel.imageSelection, matching: .images, photoLibrary: .shared())
            
            .onChange(of: imageLoaderViewModel.imageToUpload, { _, newValue in
                if let newValue = newValue {
                    viewModel.displayedRecipeImage = Image(uiImage: newValue)
                    viewModel.recipeImage = newValue
                }
            })
            .confirmationDialog("Upload an image to your recipe", isPresented: $viewModel.showImageOptions, titleVisibility: .visible) {
                Button(action: {
                    viewModel.showLibrary = true
                }, label: {
                    Text("Upload from Library")
                })
                Button(action: {
                    
                }, label: {
                    Text("Upload from Camera")
                })
               
            }
            if viewModel.isUploading {
                ProgressComponentView(value: $viewModel.uploadProgress)
            }
            
        }
        
    }
}

#Preview {
    AddRecipesView()
}
