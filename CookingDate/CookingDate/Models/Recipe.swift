//
//  Recipe.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 03.03.25.
//

import Foundation


struct Recipe: Identifiable, Codable {
    let id: String
    let image: String
    let name: String
    let description: String
    let difficulty: String
    let ingredients: String
    let time: Int
    
    init(id: String, image: String, name: String, description: String, difficulty: String, ingredients: String, time: Int) {
        self.id = id
        self.image = image
        self.name = name
        self.description = description
        self.difficulty = difficulty
        self.ingredients = ingredients
        self.time = time
    }
}

extension Recipe {
    
    static var mockRecipes = [
        Recipe(id: UUID().uuidString, image: "Risotto", name: "Classic Risotto", description: "A classic Risotto for those who never tried to cook it before.", difficulty: "Easy", ingredients: "1/4 cup olive oil, 400g of ristto rice, 2L chicken broth, 2/4 Parmigigano cheese.", time: 10),
        Recipe(id: UUID().uuidString, image: "Tiramisu", name: "Tiramisu", description: "this delicious and unbelievably Tiramisu recipe is made with coffe soaked lady fingers", difficulty: "Medium", ingredients: "1 1/2 cup whipping cream, 8 ounce mascarpone cheese, 1/3 cup granulated sugar, 1 teaspoon vanilla extract, 1 1/2 cold espresso, 1 package Lady Fingers, cocoa powder.", time: 90),
        Recipe(id: UUID().uuidString, image: "Carbo", name: "Granny's Carbonara", description: "A delicious Carbonara wth Granny’s special secret.", difficulty: "Easy", ingredients: "100g Pancetta, 50g Pecorino cheese, 3 eggs, 350g Spaghetti.", time: 20),
    
    ]
}
