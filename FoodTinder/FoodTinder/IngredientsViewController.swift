//
//  IngredientsViewController.swift
//  FoodTinder
//
//  Created by Sami Khalil on 21/5/19.
//  Copyright © 2019 Alex Lin. All rights reserved.
//

import UIKit

class IngredientsViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailLabel: UIImageView!
    @IBOutlet weak var ingredientsLabel: UITextView!
    @IBOutlet weak var ingredientTitle: UILabel!
    
    // need this to pass to an api to get the ingredients
    var recipeID: String?
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if there is a recipe, load the content
        if let myRecipe = recipe {
            loadRecipe(recipe: myRecipe)
        }

    }
    
    func loadRecipe(recipe: Recipe){
        
        // Ingredients API is only called if ingredients is null.
        if let ingredients = recipe.ingredients {
            
            var ingredientsText = ""
            ingredients.forEach { ingredient in
                ingredientsText.append(ingredient)
                ingredientsText.append("\n")
            }
            
            ingredientTitle.text = "Ingredients";
            ingredientsLabel.text = ingredientsText
            
        } else {
            recipe.getIngredients() { [weak self] ingredients in
                
                var ingredientsText = ""
                ingredients.forEach { ingredient in
                    ingredientsText.append(ingredient)
                    ingredientsText.append("\n")
                }
                DispatchQueue.main.async {
                    self?.ingredientTitle.text = "Ingredients";
                    self?.ingredientsLabel.text = ingredientsText
                }
            }
        }
        
        titleLabel.text = recipe.title
        recipe.loadImage(imageView: thumbnailLabel)
    }
    
    @IBAction func back() {
        dismiss(animated: true, completion: nil)
    }
}
