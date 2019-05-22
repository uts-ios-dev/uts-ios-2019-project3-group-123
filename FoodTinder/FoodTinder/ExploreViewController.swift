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
    var recipes: [Recipe] = []
    let totalCards: Int = 4
    var currentRecipe = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        SwipableCard.total = totalCards
        
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
            //ingredientsScreen.titleLabel.text = SwipableCard.currentTop?.title.text
            //ingredientsScreen.thumbnailLabel.image = SwipableCard.currentTop?.imageView.image
            
        }
    }
    
    @IBAction func swipeLeft(_ sender: UIButton) {
        SwipableCard.currentTop?.swipe(.left)
    }
    
    
}
