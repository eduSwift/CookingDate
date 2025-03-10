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
    var searchText: String = ""
    
    private let repository: MealRepository
    
    init(repository: MealRepository = APIMealRepository()) {
        self.repository = repository
        loadRecipes()
    }
    
    func loadRecipes() {
        Task{
            do {
                self.meals = try await repository.fetchMealByName(mealName: "a")
            } catch {
                print("error loading data")
            }
        }
    }
    
    var filteredMeals: [Meal] {
        searchText.isEmpty ? meals : meals.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
}

