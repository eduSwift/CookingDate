//
//  RecipeViewModel.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 03.03.25.
//



import Foundation
import SwiftUI
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

@Observable
class RecipesViewModel {
    var recipes: [Recipe] = []
    var recipeToEdit: Recipe?
    var isEditingRecipe = false
    var recipeName = ""
    var preparationTime = 0
    var description = ""
    var difficulty = ""
    var ingredientsInput = "" {
        didSet {
            if ingredientsInput.last == "\n" {
                ingredientsInput += "• "
            }
        }
    }

    var formattedIngredients: [String] {
        ingredientsInput
            .components(separatedBy: "• ")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    var createdAt = Date()
    var showImageOptions = false
    var showLibrary = false
    var displayedRecipeImage: Image?
    var recipeImage: UIImage?
    var uploadProgress: Float = 0
    var isLoading = false

    func fetchUserRecipes(userId: String) {
        Firestore.firestore().collection("recipes")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error fetching recipes: \(error.localizedDescription)")
                        self.recipes = []
                        return
                    }
                    self.recipes = snapshot?.documents.compactMap { doc in
                        try? doc.data(as: Recipe.self)
                    } ?? []
                }
            }
    }

    func deleteRecipe(_ recipe: Recipe) {
        let id = recipe.id  // no optional unwrapping
        Firestore.firestore().collection("recipes").document(id).delete { error in
            if let error = error {
                print("❌ Failed to delete: \(error.localizedDescription)")
            } else {
                print("✅ Deleted recipe: \(recipe.name)")
                self.recipes.removeAll { $0.id == id }
            }
        }
    }


    func addRecipe(imageURL: URL, handler: @escaping (_ success: Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            handler(false)
            return
        }
        guard recipeName.count >= 2 else {
            handler(false)
            return
        }
        guard description.count >= 5 else {
            handler(false)
            return
        }
        guard preparationTime != 0 else {
            handler(false)
            return
        }
        guard ingredientsInput.count >= 2 else {
            handler(false)
            return
        }

        isLoading = true
        let ref = Firestore.firestore().collection("recipes").document()

        let recipe = Recipe(id: ref.documentID, image: imageURL.absoluteString, name: recipeName, description: description, difficulty: difficulty, ingredients: ingredientsInput, time: preparationTime, userId: userId)

        do {
            try Firestore.firestore().collection("recipes").document(ref.documentID).setData(from: recipe) { error in
                if let error = error {
                    print(error.localizedDescription)
                    handler(false)
                    self.isLoading = false
                    return
                }
                self.isLoading = false
                handler(true)

                Task {
                    await self.fetchRecipes()
                }
            }

        } catch {
            isLoading = false
            handler(false)
        }
    }

    func upload() async -> URL? {
        guard let userId = Auth.auth().currentUser?.uid else {
            return nil
        }

        guard let recipeImage = recipeImage,
              let imageData = recipeImage.jpegData(compressionQuality: 0.7) else {
            return nil
        }

        let imageID = UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "_")
        let imageName = "\(imageID).jpeg"
        let imagePath = "images\(userId)/\(imageName)"

        let storageRef = Storage.storage().reference(withPath: imagePath)

        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        isLoading = true

        do {
            let _ = try await storageRef.putDataAsync(imageData, metadata: metaData) { progress in
                if let progress = progress {
                    let percentComplete = Float(progress.completedUnitCount / progress.totalUnitCount)
                    self.uploadProgress = percentComplete
                }
            }

            isLoading = false
            let donwloadURL = try await storageRef.downloadURL()
            return donwloadURL
        } catch {
            isLoading = false
            return nil
        }
    }

    func observe(onChange: @escaping ([Recipe]) -> Void) throws {
        guard (Auth.auth().currentUser?.uid) != nil else {
            return
        }
        Firestore.firestore().collection("recipes").addSnapshotListener(includeMetadataChanges: false) { snapshot, error in
            if error != nil { return }
            guard let snapshot = snapshot else { return }

            let todos = snapshot.documents.compactMap { document in
                try? document.data(as: Recipe.self)
            }

            onChange(todos)
        }
    }

    private func observeRecipes() {
        try? self.observe { recipes in
            self.recipes = recipes
        }
    }

    init() {
        observeRecipes()
    }

    func fetchRecipes() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        do {
            let recipesResult = try await Firestore.firestore().collection("recipes").whereField("userId", isEqualTo: userId).getDocuments()

            var fetchedRecipes: [Recipe] = []

            for recipeDocument in recipesResult.documents {
                let data = recipeDocument.data()

                guard let imageLocation = data["image"] as? String,
                      let descriptions = data["description"] as? String,
                      let name = data["name"] as? String,
                      let difficulty = data["difficulty"] as? String,
                      let ingredients = data["ingredients"] as? String,
                      let userId = data["userId"] as? String,
                      let time = data["time"] as? Int,
                      data["createdAt"] is Timestamp else {
                    continue
                }

                let id = recipeDocument.documentID
                let recipe = Recipe(id: id, image: imageLocation, name: name, description: descriptions, difficulty: difficulty, ingredients: ingredients, time: time, userId: userId)
                fetchedRecipes.append(recipe)
            }

            DispatchQueue.main.async {
                self.recipes = fetchedRecipes
            }

        } catch {
            print("Error fetching recipes async: \(error.localizedDescription)")
        }
    }
}

