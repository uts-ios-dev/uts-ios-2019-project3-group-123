//
//  ViewController.swift
//  FoodTinder
//
//  Created by Alex Lin on 15/5/19.
//  Copyright © 2019 Alex Lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var recipes: [Recipe] = []
    var count: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        loadRecipesFromAPI()
    }
    
    @IBAction func browseRecipesBtn(_ sender: Any) {
//        if count != 0 {
//            performSegue(withIdentifier: "toBrowseScreen", sender: self)
//        }
    }
    
    func loadRecipesFromAPI() {
        let recipesAPI = "https://www.food2fork.com/api/search?key=018db47a955019294137b4e94194d624"
        
        guard let url = URL(string: recipesAPI) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            print("API called")
            
            let decoder = JSONDecoder()
            
            do {
                let recipeResults = try decoder.decode(RecipeAPI.self, from: data)
                print("Successfully decoded")
                
                self.recipes = recipeResults.recipes
                self.count = recipeResults.count
                
            } catch {
                print("Failed to decode recipe: \(error.localizedDescription)")
            }
            
        }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBrowseScreen" {
            let browseScreen = segue.destination as! ExploreViewController
            browseScreen.recipes = recipes
            browseScreen.totalCards = count
        }
    }
}

