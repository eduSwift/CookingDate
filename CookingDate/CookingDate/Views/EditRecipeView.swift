//
//  EditRecipeView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 17.03.25.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore

struct EditRecipeView: View {
    @Bindable var viewModel = RecipesViewModel()
    var recipe: Recipe
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
                                            AsyncImage(url: URL(string: recipe.image)) { image in
                                                image.resizable()
                                                    .scaledToFill()
                                            } placeholder: {
                                                Image(systemName: "photo.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 50, height: 50)
                                                    .foregroundColor(.gray)
                                            }
                                            .frame(height: 200)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                        }
                                    }
                                )
                        }
                    }

                    TextField("Recipe Name", text: $viewModel.recipeName)
                        .padding()
                        .background(Color.primaryFormEntry)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    TextField("Description", text: $viewModel.description)
                        .frame(height: 80)
                        .padding(8)
                        .background(Color.primaryFormEntry)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    Picker("Time", selection: $viewModel.preparationTime) {
                        ForEach(0...120, id: \.self) { time in
                            if time % 5 == 0 {
                                Text("\(time) mins").tag(time)
                            }
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    TextField("Difficulty", text: $viewModel.difficulty)
                        .padding()
                        .background(Color.primaryFormEntry)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

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

                    Button("Save Changes") {
                        Task {
                            var imageURL: URL? = URL(string: recipe.image)
                            if let newImage = viewModel.recipeImage {
                                imageURL = await viewModel.upload()
                            }
                            guard let finalURL = imageURL else { return }

                            let updatedRecipe = Recipe(
                                id: recipe.id,
                                image: finalURL.absoluteString,
                                name: viewModel.recipeName,
                                description: viewModel.description,
                                difficulty: viewModel.difficulty,
                                ingredients: viewModel.ingredientsInput,
                                time: viewModel.preparationTime,
                                userId: recipe.userId
                            )

                            do {
                                try Firestore.firestore().collection("recipes")
                                    .document(recipe.id)
                                    .setData(from: updatedRecipe)
                                dismiss()
                            } catch {
                                print("❌ Failed to save edited recipe: \(error.localizedDescription)")
                            }
                        }
                    }
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding()
                .onAppear {
                    viewModel.recipeName = recipe.name
                    viewModel.description = recipe.description
                    viewModel.preparationTime = recipe.time
                    viewModel.difficulty = recipe.difficulty
                    viewModel.ingredientsInput = recipe.ingredients.map { "• \($0)" }.joined(separator: "\n")

                }
            }

            .photosPicker(isPresented: $viewModel.showLibrary, selection: $imageLoaderViewModel.imageSelection, matching: .images)
            .onChange(of: imageLoaderViewModel.imageToUpload) { _, newValue in
                if let newValue = newValue {
                    viewModel.displayedRecipeImage = Image(uiImage: newValue)
                    viewModel.recipeImage = newValue
                }
            }
            .confirmationDialog("Upload an image to your recipe", isPresented: $viewModel.showImageOptions) {
                Button("Upload from Library") { viewModel.showLibrary = true }
                Button("Upload from Camera") { }
            }

            if viewModel.isLoading {
                LoadingComponentView()
            }
        }
    }
}

#Preview {
    EditRecipeView(recipe: Recipe(id: "1", image: "", name: "", description: "", difficulty: "", ingredients: "", time: 15, userId: "abc123"))
}
