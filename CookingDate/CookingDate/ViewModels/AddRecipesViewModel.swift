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

@Observable
class AddRecipesViewModel {
    
    var recipeName = ""
    var preparationTime = 0
    var desctiption = ""
    var difficulty = ""
    var ingredient = ""
    var createdAt = Date()
    var showImageOptions = false
    var showLibrary = false
    var displayedRecipeImage: Image?
    var recipeImage: UIImage?
    var uploadProgress: Float = 0
    
    func upload() async {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        guard let recipeImage = recipeImage,
        let imageData = recipeImage.jpegData(compressionQuality: 0.7) else {
            return
        }
        
        
        
        let imageID = UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "_")
        let imageName = "\(imageID).jpeg"
        let imagePath = "images\(userId)/\(imageName)"
        
        let storageRef = Storage.storage().reference(withPath: imagePath)
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        do {
            let _ = try await storageRef.putDataAsync(imageData, metadata: metaData) { progress in
                if let progress = progress {
                    let percentComplete = Float(progress.completedUnitCount / progress.totalUnitCount)
                    self.uploadProgress = percentComplete
                    
                }
            }
            

        } catch {
            
        }
        
    }
}

