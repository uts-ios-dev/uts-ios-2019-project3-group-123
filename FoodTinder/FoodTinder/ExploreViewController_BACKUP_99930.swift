//
//  ExploreViewController.swift
//  FoodTinder
//
//  Created by Alex Lin on 18/5/19.
//  Copyright © 2019 Alex Lin. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {
    
    var cards: [SwipableCard] = []
<<<<<<< HEAD
    let totalCards: Int = 4
=======
    var currentRecipe = ""
>>>>>>> 5a4c8f2c43e774b688961e0112b0e284f44d03a5

    override func viewDidLoad() {
        super.viewDidLoad()
        SwipableCard.total = totalCards
        
        var recipes: [Recipe] = []
        for i in 0 ..< 12 {
            let recipe: Recipe = Recipe(imageName: "sample\(i%4+1)", name: "Demo\(i%4+1)", index: i)
            recipes.append(recipe)
        }
        //recipes.reverse()
        
        for i in 0 ..< SwipableCard.total {
            if let card = Bundle.main.loadNibNamed("SwipableCard", owner: self, options: nil)?.first as? SwipableCard {
                view.addSubview(card)
                let id = SwipableCard.total - 1 - i
                card.loadContent(recipe: recipes[id%recipes.count])
                card.setIndex(index: id)
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
    
    @IBAction func swipeRight(_ sender: UIButton) {
<<<<<<< HEAD
        SwipableCard.currentTop?.swipe(.right)
=======
        cards[0].swipe(.right)
        performSegue(withIdentifier: "toIngredientsScreen", sender: self)

    }
    
    @IBAction func getInfo(_ sender: Any) {
        performSegue(withIdentifier: "toIngredientsScreen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toIngredientsScreen" {
            let ingredientsScreen = segue.destination as! IngredientsViewController
            ingredientsScreen.titleLabel = cards[0].title
            ingredientsScreen.thumbnailLabel = cards[0].imageView
            
        }
>>>>>>> 5a4c8f2c43e774b688961e0112b0e284f44d03a5
    }
    
    @IBAction func swipeLeft(_ sender: UIButton) {
        SwipableCard.currentTop?.swipe(.left)
    }
}
