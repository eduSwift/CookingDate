//
//  RecipeRepository.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 28.02.25.
//

import Foundation


protocol MealRepository {
    
    func fetchMealByName(mealName: String) async throws -> [Meal]
}
