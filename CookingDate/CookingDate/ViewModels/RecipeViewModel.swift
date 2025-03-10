//
//  RecipeViewModel.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 03.03.25.
//

import Foundation
import SwiftUI
import FirebaseStorage

@Observable
class RecipeViewModel {
    
    var recipeName = ""
    var preparationTime = 0
    var desctiption = ""
    var difficulty = ""
    var ingredient = ""
    var createdAt = Date()
    var showImageOptions = false
    var showLibrary = false
    var displayedRecipeImage: Image?
    
    
    
}


