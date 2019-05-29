//
//  SavedRecipesTableViewController.swift
//  FoodTinder
//
//  Created by Sami Khalil on 22/5/19.
//  Copyright © 2019 Alex Lin. All rights reserved.
//

import UIKit

class SavedRecipesTableViewController: UITableViewController {
    
    private var savedRecipes: [SavedRecipe]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var selectedRecipe: Recipe?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        savedRecipes = CoreDataManager.retreive()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedRecipes?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SavedListCell", for: indexPath) as? SavedListCell, let recipes = savedRecipes, let imageUrl = recipes[indexPath.row].image_url {
            cell.nameLabel.text = recipes[indexPath.row].title
            loadImage(for: cell, imageUrl: imageUrl)
            return cell
        }

        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let savedRecipe = savedRecipes?[indexPath.row] {
            
            let recipe = Recipe(recipe_id: savedRecipe.recipe_id ?? "0", title: savedRecipe.title ?? "Unknown Recipe", image_url: savedRecipe.image_url ?? "", index: nil)
            selectedRecipe = recipe
            performSegue(withIdentifier: "toIngredientsScreen", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toIngredientsScreen" {
            if let ingredientsScreen = segue.destination as? IngredientsViewController {
                ingredientsScreen.recipe = selectedRecipe
            }
        }
    }
    
    // MARK: Table View helpers
    
    func loadImage(for cell: SavedListCell, imageUrl: String) {
        
        // download image
        if let url = URL(string: imageUrl) {
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                // display image to UI
                DispatchQueue.main.async {
                    cell.recipeImageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

}
