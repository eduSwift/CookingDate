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

@MainActor
@Observable
class RecipesViewModel {
    var userRecipes: [Recipe] = []
    var allRecipes: [Recipe] = []
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
                        self.userRecipes = []
                        return
                    }
                    self.userRecipes = snapshot?.documents.compactMap { doc in
                        try? doc.data(as: Recipe.self)
                    } ?? []
                }
            }
    }
    
    func observeAllRecipes() {
        Firestore.firestore().collection("recipes")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("❌ Real-time error fetching all recipes: \(error.localizedDescription)")
                        self.allRecipes = []
                        return
                    }

                    self.allRecipes = snapshot?.documents.compactMap { doc in
                        try? doc.data(as: Recipe.self)
                    } ?? []
                }
            }
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        let id = recipe.id
        Firestore.firestore().collection("recipes").document(id).delete { error in
            if let error = error {
                print("❌ Failed to delete: \(error.localizedDescription)")
            } else {
                print("✅ Deleted recipe: \(recipe.name)")
                self.userRecipes.removeAll { $0.id == id }
                self.allRecipes.removeAll { $0.id == id }
            }
        }
    }
    
    
    func addRecipe(imageURL: URL, completionHandler: @escaping (_ success: Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completionHandler(false)
            return
        }
        
        guard recipeName.count >= 2,
              description.count >= 5,
              preparationTime != 0,
              ingredientsInput.count >= 2 else {
            completionHandler(false)
            return
        }
        
        isLoading = true
        let ref = Firestore.firestore().collection("recipes").document()
        
        let recipe = Recipe(id: ref.documentID, image: imageURL.absoluteString, name: recipeName, description: description, difficulty: difficulty, ingredients: ingredientsInput, time: preparationTime, userId: userId)
        
        do {
            try Firestore.firestore().collection("recipes").document(ref.documentID).setData(from: recipe) { error in
                if let error = error {
                    print(error.localizedDescription)
                    completionHandler(false)
                    self.isLoading = false
                    return
                }
                self.isLoading = false
                completionHandler(true)
                
                Task {
                    self.fetchUserRecipes(userId: userId)
                    URLSession.shared.dataTask(with: imageURL).resume()
                }
            }
            
        } catch {
            isLoading = false
            completionHandler(false)
        }
    }
    
    func upload() async -> URL? {
        guard let userId = Auth.auth().currentUser?.uid,
              let recipeImage = recipeImage,
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
            return try await storageRef.downloadURL()
        } catch {
            isLoading = false
            return nil
        }
    }
    
    init() {
           observeAllRecipes()
           if let userId = Auth.auth().currentUser?.uid {
               fetchUserRecipes(userId: userId)
           }
       }

    
    
    func fetchRecipes() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        do {
            let recipesResult = try await Firestore.firestore().collection("recipes").whereField("userId", isEqualTo: userId).getDocuments()
            
            let fetched = recipesResult.documents.compactMap { try? $0.data(as: Recipe.self) }
            
            DispatchQueue.main.async {
                self.userRecipes = fetched
            }
        } catch {
            print("Error fetching user recipes async: \(error.localizedDescription)")
        }
    }
    
}

