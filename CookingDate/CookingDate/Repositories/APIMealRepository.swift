//
//  APIRecipeRepository.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 28.02.25.
//

import Foundation
import SwiftUI

class APIMealRepository: MealRepository {
    
    private let baseURL = "https://www.themealdb.com/api/json/v1/1"
    
    func fetchMealByName(mealName: String) async throws -> [Meal] {
        let urlString = "\(baseURL)/search.php?s=\(mealName)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MealResponse.self, from: data)
        return response.meals
    }
    
}


















    
   
