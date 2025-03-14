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
    
    var recipeName = ""
    var preparationTime = 0
    var description = ""
    var difficulty = ""
    var ingredients = ""
    var createdAt = Date()
    var showImageOptions = false
    var showLibrary = false
    var displayedRecipeImage: Image?
    var recipeImage: UIImage?
    var uploadProgress: Float = 0
    var isLoading = false
    
    
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
        
        guard ingredients.count >= 2 else {
            handler(false)
            return
        }
        
        
        
        isLoading = true
        let ref = Firestore.firestore().collection("recipes").document()
        
        let recipe = Recipe(id: ref.documentID, image: imageURL.absoluteString, name: recipeName, description: description, difficulty: difficulty, ingredients: ingredients, time: preparationTime, userId: userId)
        
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
        guard let userId = Auth.auth().currentUser?.uid else {
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
                
                guard let imageLocation = data["image"] as? String else {
                    continue
                }
                guard let descriptions = data["description"] as? String else {
                    continue
                }
                guard let name = data["name"] as? String else {
                    continue
                }
                guard let difficulty = data["difficulty"] as? String else {
                    continue
                }
                guard let ingredients = data["ingredients"] as? String else {
                    continue
                }
                guard let time = data["time"] as? Int else {
                    continue
                }
                guard let userId = data["userId"] as? String else {
                    continue
                }
                guard let time = data["time"] as? Int else {
                    continue
                }
                guard let createdAt = data["createdAt"] as? Timestamp else {
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
            
        }
        
    }
}



