//
//  Recipe.swift
//  FoodTinder
//
//  Created by Alex Lin on 19/5/19.
//  Copyright © 2019 Alex Lin. All rights reserved.
//

import UIKit

struct API_keys {
    static var keys: [String] = ["018db47a955019294137b4e94194d624", "2f2de49d072e7ad4d6de28ad29247a36", "97bf208eae7b1c390b2e8907a434aa2f"]
    static var used_keys: [String] = []
    static var currentKey: String = ""
}

// Structure for Recipe API
class RecipeAPI: Codable {
    var count: Int
    var recipes: [Recipe]
    static var page: Int?
}

// Structure for Ingredients API
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
    var ingredients: String?
    var index: Int?
    var isLiked: Bool?
    
    init(recipe_id: String, title: String, image_url: String, index: Int?, ingredients: String?) {
        self.recipe_id = recipe_id
        self.title = title
        self.image_url = image_url
        self.index = index
        self.ingredients = ingredients
    }
    
    // Call ingredients API to get the ingredients by passing in the recipe ID.
    func getIngredients(completion: @escaping ((String)->())) {
        
        let ingredientsAPI = "https://www.food2fork.com/api/get?key=018db47a955019294137b4e94194d624&rId=\(self.recipe_id)"
        
        // convert string url to type of URL
        guard let url = URL(string: ingredientsAPI) else { return }
        
        // pass url to make the api call
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // check if there is any data
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            do {
                // decode the data following the structure in IngredientsAPI
                let ingredientsResults = try decoder.decode(IngredientsAPI.self, from: data)
                let ingredients = ingredientsResults.recipe.ingredients
                
                var ingredientsText = ""
                ingredients.forEach { ingredient in
                    ingredientsText.append(ingredient)
                    ingredientsText.append("\n")
                }
                
                self.ingredients = ingredientsText
                completion(ingredientsText)
                
            } catch {
                print("Failed to decode recipe: \(error.localizedDescription)")
            }
            
        }.resume()
    }
    
    //Load image to imageView
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



