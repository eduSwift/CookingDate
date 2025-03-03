//
//  MyRecipesViewModel.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 26.02.25.
//

import Foundation
import SwiftUI

@Observable
class MealsViewModel {
    
    var meals: [Meal] = []
    var filteredRecipes: [Meal] = []
    var searchText: String = "" {
        didSet {
            filterRecipes()
        }
    }
    private let repository: MealRepository
    
    init(repository: MealRepository = APIMealRepository()) {
        self.repository = repository
        loadRecipes()
    }
    
    func loadRecipes() {
        Task{
            do {
                self.meals = try await repository.fetchMealByName(mealName: "Salad")
            } catch {
                print("error loading data")
            }
        }
    }
    
    func filterRecipes() {
        if searchText.isEmpty {
            filteredRecipes = meals
        }  else {
            filteredRecipes = meals.filter { recipe in
                recipe.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

}
