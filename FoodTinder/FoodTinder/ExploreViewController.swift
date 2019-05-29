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
        
        print("Received " + String(recipes.count) + " recipes")
        for i in 0 ..< recipes.count {
            recipes[i].index = i
        }
        
        if recipes.count != 0 {
            setCards()
        }
        
        SwipableCard.recipes = recipes
    }
    
    func setCards() {
        //SwipableCard.total = totalCards

        for i in 0 ..< SwipableCard.total {
            if let card = Bundle.main.loadNibNamed("SwipableCard", owner: self, options: nil)?.first as? SwipableCard {
                view.addSubview(card)
                card.resize()
                //let id = SwipableCard.total - 1 - i
                card.loadContent(recipe: recipes[i%recipes.count])
                card.setIndex(index: i)
                cards.append(card)
            }
        }
        for i in 0 ..< SwipableCard.total {
            cards[i].setLastCard(card: cards[(i-1+SwipableCard.total)%SwipableCard.total])
        }
        
        cards[0].enableDebug()
    }
    
    @IBAction func resetCard(_ sender: UIButton) {
        SwipableCard.currentTop?.regret()
    }
    
//    @IBAction func swipeRight(_ sender: UIButton) {
//        SwipableCard.currentTop?.swipe(.right)
//        //performSegue(withIdentifier: "toIngredientsScreen", sender: self)
//    }
    
    @IBAction func getInfo(_ sender: Any) {
        //performSegue(withIdentifier: "toIngredientsScreen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toIngredientsScreen" {
            let ingredientsScreen = segue.destination as! IngredientsViewController
            ingredientsScreen.recipe = SwipableCard.currentTop?.recipe
        }
    }
    
//    @IBAction func swipeLeft(_ sender: UIButton) {
//        SwipableCard.currentTop?.swipe(.left)
//    }
    
    
}
