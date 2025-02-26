//
//  Receipe.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 24.02.25.
//

import Foundation

struct Recipe: Identifiable, Codable {
    let id: String
    let image: String
    let name: String
    let description: String
    let time: Int
    
    init(id: String, name: String, image: String, description: String, time: Int) {
        self.id = id
        self.name = name
        self.image = image
        self.description = description
        self.time = time
    }
}

extension Recipe {
    
    static var mockRecipes = [
        Recipe(id: UUID().uuidString, name: "Risotto", image: "Risotto", description: "To prepare a classic risotto, start by preheating your oven to 400°F for the potatoes. Wash and cut the potatoes into wedges, toss them with olive oil, salt, pepper, and your choice of herbs like rosemary or thyme. Spread them on a baking sheet and roast until golden and crispy, about 25-30 minutes, turning halfway through. Meanwhile, take your steak out of the fridge and let it come to room temperature for about 20 minutes. Season it generously with salt and pepper. Heat a cast-iron skillet over high heat and add a splash of oil. Sear the steak for about 3-4 minutes on each side for medium-rare, or longer depending on the thickness and your preference. Let the steak rest for a few minutes before slicing. Serve with the roasted potatoes and a side of steamed vegetables or a fresh salad for a complete meal.", time: 40),
        Recipe(id: UUID().uuidString, name: "Burrito", image: "Burrito", description: "To prepare a delicious roast chicken, begin by preheating your oven to 375°F (190°C). Clean the chicken by removing any giblets and pat it dry with paper towels. Rub the entire surface of the chicken with olive oil and season generously inside and out with salt, pepper, and herbs like rosemary, thyme, and sage. Optionally, stuff the cavity with halved lemons and garlic cloves to enhance the flavor. Place the chicken breast-side up in a roasting pan. Tuck the wing tips under the body and tie the legs together with kitchen twine. Roast in the oven for about 20 minutes per pound, or until the internal temperature reaches 165°F (74°C) and the juices run clear. Let the chicken rest for 10 minutes before carving to allow the juices to redistribute. Serve with roasted vegetables or a light salad for a hearty, satisfying meal.", time: 50),
        Recipe(id: UUID().uuidString, name: "Carbonara", image: "Carbo", description: "To prepare pasta, start by bringing a large pot of salted water to a boil. Choose your pasta shape and add it to the boiling water, stirring occasionally to prevent sticking. Follow the cooking time suggested on the package, typically between 8 to 12 minutes, until the pasta is al dente, which means it should be tender but still firm to the bite. While the pasta cooks, you can prepare a sauce of your choice, such as a quick garlic and olive oil sauté, a creamy Alfredo, or a hearty marinara. Once the pasta is cooked, drain it, reserving a cup of the pasta water. Return the pasta to the pot and mix it with your sauce, adding a bit of the reserved pasta water to help the sauce cling to the pasta smoothly. Serve immediately with a sprinkle of grated Parmesan cheese and fresh herbs for an extra touch of flavor.", time: 60),
        Recipe(id: UUID().uuidString, name: "Quinoa Bowl", image: "Quinoa", description: "To prepare a basic omelette, start by beating 2-3 eggs in a bowl with a pinch of salt and pepper. Heat a non-stick skillet over medium heat and add a small amount of butter or oil. Once the butter is melted or the oil is hot, pour in the eggs. As the eggs begin to set, gently lift the edges with a spatula, allowing the uncooked eggs to flow underneath. When the eggs are mostly set but still slightly runny on top, add your chosen fillings—such as cheese, diced vegetables, herbs, or cooked meats—on one half of the omelette. Carefully fold the other half over the fillings. Let it cook for another minute or so, until the cheese is melted and the omelette is cooked through. Slide the omelette onto a plate and serve immediately. Enjoy a customizable and quick meal that's perfect for breakfast or a light dinner.", time: 10),
        Recipe(id: UUID().uuidString, name: "Tiramisu", image: "Tiramisu", description: "To prepare pasta, start by bringing a large pot of salted water to a boil. Choose your pasta shape and add it to the boiling water, stirring occasionally to prevent sticking. Follow the cooking time suggested on the package, typically between 8 to 12 minutes, until the pasta is al dente, which means it should be tender but still firm to the bite. While the pasta cooks, you can prepare a sauce of your choice, such as a quick garlic and olive oil sauté, a creamy Alfredo, or a hearty marinara. Once the pasta is cooked, drain it, reserving a cup of the pasta water. Return the pasta to the pot and mix it with your sauce, adding a bit of the reserved pasta water to help the sauce cling to the pasta smoothly. Serve immediately with a sprinkle of grated Parmesan cheese and fresh herbs for an extra touch of flavor.", time: 20),
        Recipe(id: UUID().uuidString, name: "Lasagna", image: "Lasagna", description: "To prepare a classic lasagna, start by preheating your oven to 375°F (190°C). First, prepare the meat sauce by sautéing chopped onions and garlic in olive oil until translucent. Add ground beef or a mix of beef and pork, and cook until browned. Stir in a can of crushed tomatoes, basil, oregano, salt, and pepper, and let it simmer for about 20 minutes. In a separate bowl, mix ricotta cheese with an egg, grated Parmesan, and chopped parsley. To assemble the lasagna, spread a layer of meat sauce in a baking dish, followed by a layer of lasagna noodles (no need to boil if using oven-ready noodles). Spread a layer of the ricotta mixture over the noodles, and sprinkle with shredded mozzarella. Repeat the layers until all ingredients are used, finishing with a generous layer of cheese. Cover with foil and bake for 25 minutes, then remove the foil and bake for another 25 minutes until the top is bubbly and golden. Allow it to rest for 15 minutes before slicing to help the layers set. Serve warm with a side of garlic bread or a green salad.", time: 30)
        
    ]
}
