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
    let totalCards: Int = 4

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
        SwipableCard.currentTop?.swipe(.right)
    }
    
    @IBAction func swipeLeft(_ sender: UIButton) {
        SwipableCard.currentTop?.swipe(.left)
    }
}
