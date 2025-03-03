//
//  Receipe.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 24.02.25.
//

import Foundation

struct Meal: Identifiable, Codable {
    let id: String
    let image: String
    let name: String
    let description: String

    
    
    enum CodingKeys: String, CodingKey {
        
        case id = "idMeal"
        case image = "strMealThumb"
        case name = "strMeal"
        case description = "strInstructions"
      
        
    }
    
    init(id: String, name: String, image: String, description: String) {
        self.id = id
        self.name = name
        self.image = image
        self.description = description
       
    }
}





