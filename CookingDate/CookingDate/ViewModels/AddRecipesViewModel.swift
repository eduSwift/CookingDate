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
    var desctiption = ""
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
            return
        }
        guard recipeName.count >= 2 else {
            return
        }
        
        guard desctiption.count >= 5 else {
            return
        }
        
        guard preparationTime != 0 else {
            return
        }
        
        guard ingredients.count >= 2 else {
            return
        }
        
        guard let imageURL = await upload() else {
            return
        }
        
        let ref = Firestore.firestore().collection("recipes").document()
        
        let recipe = Recipe(id: ref.documentID, image: imageURL.absoluteString, name: recipeName, description: desctiption, difficulty: difficulty, ingredients: ingredients, time: preparationTime, userId: userId)
        
        do {
            try Firestore.firestore().collection("recipes").addDocument(from: recipe)
        } catch {
            
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

