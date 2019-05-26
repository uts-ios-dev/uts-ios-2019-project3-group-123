//
//  Recipe.swift
//  FoodTinder
//
//  Created by Alex Lin on 19/5/19.
//  Copyright © 2019 Alex Lin. All rights reserved.
//

import Foundation

let APIExample = """
            [
                {
                    "count": 30,
                    "recipes": [
                        {
                            "recipe_id": "4",
                            "title": "beef",
                            "image_url": "exe.png",
                            "publisher": "asd",
                            "social_rank": 12
                        },
                        {
                            "recipe_id": "5",
                            "title": "pizza",
                            "image_url": "exe.png",
                            "publisher": "ds",
                            "social_rank": 12
                        },
                        {
                            "recipe_id": "6",
                            "title": "burger",
                            "image_url": "exe.png",
                            "publisher": "asd",
                            "social_rank": 12
                        }
                    ]
                }
            ]
        """.data(using: .utf8)!



class RecipeAPI: Codable {
    var count: Int
    var recipes: [Recipe]
}

class Recipe: Codable {
    var recipe_id: String
    var title: String
    var image_url: String
    var publisher: String
    var social_rank: Double
    var ingredients: [String]?
    var index: Int?
    var isLiked: Bool?
    
    init(recipe_id: String, title: String, image_url: String, publisher: String, social_rank: Double, index: Int?) {
        self.recipe_id = recipe_id
        self.title = title
        self.image_url = image_url
        self.publisher = publisher
        self.social_rank = social_rank
        self.index = index
    }
    
    // Calls an api to get the ingredients by passing the recipe_id
    func getIngredients() {
        let ingredientsAPI = "https://www.food2fork.com/api/get?key=018db47a955019294137b4e94194d624&rId=\(self.recipe_id)"
        
        guard let url = URL(string: ingredientsAPI) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            do {
                
                let ingredientsResults = try decoder.decode(Recipe.self, from: data)
                
                print(ingredientsResults)
                // TODO: Need to set the ingredients from the api to self.ingredients
                //setIngredients(ingredients: ingredientsResults.ingredients)
                
            } catch {
                print("Failed to decode recipe: \(error.localizedDescription)")
            }
            
        }.resume()
    }
    
    func setIngredients(ingredients: [String]) {
        self.ingredients = ingredients
    }
    
}



