//
//  ExploreViewController.swift
//  FoodTinder
//
//  Created by Alex Lin on 18/5/19.
//  Copyright © 2019 Alex Lin. All rights reserved.
//

import UIKit
import Foundation

class ExploreViewController: UIViewController {
    
    var cards: [SwipableCard] = []
    var recipes: [Recipe] = []
    var currentRecipe = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        getRecipes()
    }
    
    func getSamples() {
        
    }
    
    func getRecipes() {
        let recipesAPI = "https://www.food2fork.com/api/search?key=018db47a955019294137b4e94194d624"
        //let recipesAPI = String(APIExample)
        
        guard let url = URL(string: recipesAPI) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }

            let decoder = JSONDecoder()
            do {
                let recipeResults = try decoder.decode(RecipeAPI.self, from: data)
                
                DispatchQueue.main.async {
                    self.recipes = recipeResults.recipes
                    //self.totalCards = self.recipes.count
                    SwipableCard.recipes = self.recipes
                    self.setCards()
                }
            
                for recipe in self.recipes {
                    print(recipe.recipe_id + " " + recipe.title)
                }
                
            } catch {
                print("Failed to decode recipe: \(error.localizedDescription)")
            }
            
        }.resume()
        
    }
    
    func setCards() {
        for i in 0 ..< SwipableCard.total {
            if let card = Bundle.main.loadNibNamed("SwipableCard", owner: self, options: nil)?.first as? SwipableCard {
                view.addSubview(card)
                let id = SwipableCard.total - 1 - i
                card.loadContent(recipe: recipes[i%recipes.count])
                card.setIndex(index: id)
                cards.append(card)
            }
        }
        for i in 0 ..< SwipableCard.total {
            cards[i].setLastCard(card: cards[(i-1+SwipableCard.total)%SwipableCard.total])
        }
        
        //cards[0].enableDebug()
    }
    
    func loadRecipe(_ recipe: Recipe, to card: SwipableCard) {
        card.loadContent(recipe: recipe)
    }
    
    @IBAction func resetCard(_ sender: UIButton) {
        SwipableCard.currentTop?.regret()
    }
    
    @IBAction func swipeRight(_ sender: UIButton) {
        SwipableCard.currentTop?.swipe(.right)
        //performSegue(withIdentifier: "toIngredientsScreen", sender: self)
    }
    
    @IBAction func getInfo(_ sender: Any) {
        //performSegue(withIdentifier: "toIngredientsScreen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toIngredientsScreen" {
            let ingredientsScreen = segue.destination as! IngredientsViewController
            ingredientsScreen.recipe = SwipableCard.currentTop?.recipe
        }
    }
    
    @IBAction func swipeLeft(_ sender: UIButton) {
        SwipableCard.currentTop?.swipe(.left)
    }
    
    
}
