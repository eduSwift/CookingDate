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
class AddRecipesViewModel {
    
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
    var isUploading = false
    
    
    func addRecipe() async {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User is not logged in")
            return
        }
        guard recipeName.count >= 2 else {
            print("Recipe name is too short")
            return
        }
        
        guard description.count >= 5 else {
            print("Description is too short")
            return
        }
        
        guard preparationTime != 0 else {
            print("Invalid preparation time")
            return
        }
        
        guard ingredients.count >= 2 else {
            print("Ingredients are too short")
            return
        }
        
        guard let imageURL = await upload() else {
            print("Image upload failed")
            return
        }
        
        let ref = Firestore.firestore().collection("recipes").document()
        
        let recipe = Recipe(id: ref.documentID, image: imageURL.absoluteString, name: recipeName, description: description, difficulty: difficulty, ingredients: ingredients, time: preparationTime, userId: userId)
        
        do {
            try Firestore.firestore().collection("recipes").document(ref.documentID).setData(from: recipe)
            print("Recipe successfully added!")
        } catch {
            print("Error adding recipe: \(error.localizedDescription)")
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
        isUploading = true
        
        do {
            let _ = try await storageRef.putDataAsync(imageData, metadata: metaData) { progress in
                if let progress = progress {
                    let percentComplete = Float(progress.completedUnitCount / progress.totalUnitCount)
                    self.uploadProgress = percentComplete
                    
                }
            }
            
            isUploading = false
            let donwloadURL = try await storageRef.downloadURL()
            return donwloadURL
        } catch {
            isUploading = false
            return nil
        }
    }
}

