//
//  MyRecipesView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 26.02.25.
//

import SwiftUI
import PhotosUI

struct AddRecipesView: View {
    
    @Bindable var viewModel = RecipesViewModel()
    @StateObject var imageLoaderViewModel = ImageLoaderViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    Button(action: {
                        viewModel.showImageOptions = true
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.primaryFormEntry)
                                .frame(height: 200)
                                .overlay(
                                    Group {
                                        if let displayedImage = viewModel.displayedRecipeImage {
                                            displayedImage
                                                .resizable()
                                                .scaledToFill()
                                                .frame(height: 200)
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                        } else {
                                            Image(systemName: "photo.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                )
                        }
                    }
                    
                    Text("Recipe Name")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Enter recipe name", text: $viewModel.recipeName)
                        .padding()
                        .background(Color.primaryFormEntry)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Text("Description")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Enter recipe description", text: $viewModel.description)
                        .frame(height: 80)
                        .padding(8)
                        .background(Color.primaryFormEntry)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Text("Preparation Time")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Picker("Select time", selection: $viewModel.preparationTime) {
                            ForEach(0...120, id: \.self) { time in
                                if time % 5 == 0 {
                                    Text("\(time) mins").tag(time)
                                }
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    
                    Text("Difficulty")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Enter difficulty level", text: $viewModel.difficulty)
                        .padding()
                        .background(Color.primaryFormEntry)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Text("Ingredients")
                                         .font(.headline)
                                         .frame(maxWidth: .infinity, alignment: .leading)
                                     
                                     TextEditor(text: $viewModel.ingredientsInput)
                                         .frame(height: 150)
                                         .padding(8)
                                         .background(Color.primaryFormEntry)
                                         .clipShape(RoundedRectangle(cornerRadius: 8))
                                         .overlay(alignment: .topLeading) {
                                             if viewModel.ingredientsInput.isEmpty {
                                                 Text("Start with '• ' and press return for new bullets\nExample:\n• Flour\n• Sugar\n• Milk")
                                                     .foregroundColor(.gray)
                                                     .padding(12)
                                             }
                                         }
                                         .onAppear {
                                             if viewModel.ingredientsInput.isEmpty {
                                                 viewModel.ingredientsInput = "• "
                                             }
                                         }
                    
                    Button(action: {
                        Task {
                            if let imageURL = await
                                viewModel.upload() {
                                viewModel.addRecipe(imageURL: imageURL) { success in
                                    if success {
                                        dismiss()
                                    }
                                }
                            }
                            
                        }
                    }) {
                        Text("Save Recipe")
                            .font(.system(size: 18, weight: .semibold))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding()
            }
            .photosPicker(isPresented: $viewModel.showLibrary, selection: $imageLoaderViewModel.imageSelection, matching: .images, photoLibrary: .shared())
            .onChange(of: imageLoaderViewModel.imageToUpload, { _, newValue in
                if let newValue = newValue {
                    viewModel.displayedRecipeImage = Image(uiImage: newValue)
                    viewModel.recipeImage = newValue
                }
            })
            .confirmationDialog("Upload an image to your recipe", isPresented: $viewModel.showImageOptions, titleVisibility: .visible) {
                Button("Upload from Library") { viewModel.showLibrary = true }
                Button("Upload from Camera") { }
            }
            
            if viewModel.isLoading {
                ProgressComponentView(value: $viewModel.uploadProgress)
                    .background(Color.black.opacity(0.5))
                    .edgesIgnoringSafeArea(.all)
            }
            if viewModel.isLoading {
                LoadingComponentView()
            }
        }
    }
}


#Preview {
    AddRecipesView()
}
