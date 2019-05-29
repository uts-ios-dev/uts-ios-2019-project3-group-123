//
//  Recipe.swift
//  FoodTinder
//
//  Created by Alex Lin on 19/5/19.
//  Copyright © 2019 Alex Lin. All rights reserved.
//

import UIKit

// api keys: 018db47a955019294137b4e94194d624, 2f2de49d072e7ad4d6de28ad29247a36, 97bf208eae7b1c390b2e8907a434aa2f
class RecipeAPI: Codable {
    var count: Int
    var recipes: [Recipe]
}

class IngredientsAPI: Codable {
    var recipe: IngredientsResult
}

class IngredientsResult: Codable {
    let ingredients: [String]
}

class Recipe: Codable {
    var recipe_id: String
    var title: String
    var image_url: String
    var ingredients: [String]?
    var index: Int?
    var isLiked: Bool?
    
    init(recipe_id: String, title: String, image_url: String, index: Int?) {
        self.recipe_id = recipe_id
        self.title = title
        self.image_url = image_url
        self.index = index
    }
    
    // Calls an api to get the ingredients by passing the recipe_id
    func getIngredients(completion: @escaping (([String])->())) {
        let ingredientsAPI = "https://www.food2fork.com/api/get?key=2f2de49d072e7ad4d6de28ad29247a36&rId=\(self.recipe_id)"
        
        guard let url = URL(string: ingredientsAPI) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            do {
                
                let ingredientsResults = try decoder.decode(IngredientsAPI.self, from: data)
                let ingredients = ingredientsResults.recipe.ingredients
                self.ingredients = ingredients
                print("Ingredients api called successfully")
                completion(ingredients)
                
            } catch {
                print("Failed to decode recipe: \(error.localizedDescription)")
            }
            
        }.resume()
    }
    
    func loadImage(imageView: UIImageView) {
        
        // download image
        if let url = URL(string: image_url) {
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                // display image to UI
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}



