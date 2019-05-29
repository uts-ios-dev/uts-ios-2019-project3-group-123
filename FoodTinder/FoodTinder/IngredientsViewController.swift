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
    
    // need this to pass to an api to get the ingredients
    var recipeID: String?
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let myRecipe = recipe {
            loadRecipe(recipe: myRecipe)
        }

    }
    
    func loadRecipe(recipe: Recipe){
        titleLabel.text = recipe.title
        //thumbnailLabel.image = UIImage(named: recipe.image_url)
        recipe.loadImage(imageView: thumbnailLabel)
    }
    
    @IBAction func back() {
        dismiss(animated: true, completion: nil)
    }
}
