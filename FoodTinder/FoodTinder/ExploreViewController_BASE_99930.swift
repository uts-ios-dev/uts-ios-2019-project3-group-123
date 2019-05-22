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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var recipes: [Recipe] = []
        for i in 1 ... 4 {
            let recipe: Recipe = Recipe(imageName: "sample\(i)", name: "Demo\(i)", index: i)
            recipes.append(recipe)
        }
        
        for i in 0 ..< 4 {
            if let card = Bundle.main.loadNibNamed("SwipableCard", owner: self, options: nil)?.first as? SwipableCard {
                view.addSubview(card)
                card.loadContent(recipe: recipes[i])
                card.setIndex(index: 3-i)
                cards.append(card)
            }
        }
    }
    
    @IBAction func resetCard(_ sender: UIButton) {
        cards[0].back()
    }
    
    @IBAction func swipeRight(_ sender: UIButton) {
        cards[0].swipe(.right)
    }
    
    @IBAction func swipeLeft(_ sender: UIButton) {
        cards[0].swipe(.left)
    }
}
