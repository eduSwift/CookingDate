//
//  MyRecipesViewModel.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 26.02.25.
//

import Foundation
import SwiftUI

@Observable
class MyRecipesViewModel {
    
    var recipes: [Recipe] = []
    private let repository: RecipeRepository
    
    init(repository: RecipeRepository = APIRecipeRepository()) {
        self.repository = repository
        loadRecipes()
    }
    
    func loadRecipes() {
        Task{
            do {
                self.recipes = try await repository.fetchMealByName(mealName: "Salad")
            } catch {
                print("error loading data")
            }
        }
    }

}
