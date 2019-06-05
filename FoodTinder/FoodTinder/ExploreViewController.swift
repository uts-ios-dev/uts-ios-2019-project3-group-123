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
    var totalCards: Int = 0
    var currentRecipe = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set an index for every recipe
        for i in 0 ..< recipes.count {
            recipes[i].index = i
        }
        
        // if there are any recipes, display the cards.
        if recipes.count != 0 {
            setCards()
        }
        
        SwipableCard.recipes = recipes
    }
    
    // displays each recipe and its content on the UI
    // inject the recipes into the cards and initialize them
    func setCards() {
        for i in 0 ..< SwipableCard.total {
            if let card = Bundle.main.loadNibNamed("SwipableCard", owner: self, options: nil)?.first as? SwipableCard {
                view.addSubview(card)
                card.resize()

                var recipeIndex = i%recipes.count
                card.loadContent(recipe: recipes[recipeIndex])
                
                card.setIndex(index: i)
                cards.append(card)
                
                recipes.remove(at: recipeIndex)
            }
        }
        for i in 0 ..< SwipableCard.total {
            cards[i].setLastCard(card: cards[(i-1+SwipableCard.total)%SwipableCard.total])
        }
        
        cards[0].enableDebug()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toIngredientsScreen" {
            let ingredientsScreen = segue.destination as! IngredientsViewController
            ingredientsScreen.recipe = SwipableCard.currentTop?.recipe
        }
    }
}
