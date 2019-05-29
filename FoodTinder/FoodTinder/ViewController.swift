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
        
        loadSampleData()
        //loadRecipesFromAPI()
    }
    
    @IBAction func browseRecipesBtn(_ sender: Any) {
        if count != 0 {
            performSegue(withIdentifier: "toBrowseScreen", sender: self)
        }
    }
    
    func loadRecipesFromAPI() {
        let recipesAPI = "https://www.food2fork.com/api/search?key=2f2de49d072e7ad4d6de28ad29247a36"
        
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
    
    
    // Instead of calling the food api, you can use this sample api for development.
    func loadSampleData() {
        
        let sampleAPI = """
            {
                "count": 7,
                "recipes": [
                    {
                        "recipe_id": "1",
                        "title": "this is a very very long title to test the uiview",
                        "image_url": "exe.png",
                        "publisher": "john",
                        "social_rank": 12
                    },
                    {
                        "recipe_id": "2",
                        "title": "2pizza",
                        "image_url": "1",
                        "publisher": "jack",
                        "social_rank": 10
                    },
                    {
                        "recipe_id": "3",
                        "title": "3burger",
                        "image_url": "4",
                        "publisher": "tom",
                        "social_rank": 7
                    },
                    {
                        "recipe_id": "4",
                        "title": "4pork",
                        "image_url": "exe.png",
                        "publisher": "john",
                        "social_rank": 12
                    },
                    {
                        "recipe_id": "5",
                        "title": "5noodle",
                        "image_url": "exe.png",
                        "publisher": "jack",
                        "social_rank": 10
                    },
                    {
                        "recipe_id": "6",
                        "title": "6dumpling",
                        "image_url": "exe.png",
                        "publisher": "tom",
                        "social_rank": 7
                    },
                    {
                        "recipe_id": "7",
                        "title": "7pasta",
                        "image_url": "exe.png",
                        "publisher": "way",
                        "social_rank": 10
                    }
                ]
            }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        
        do {
            let recipeResults = try decoder.decode(RecipeAPI.self, from: sampleAPI)
            self.recipes = recipeResults.recipes
            self.count = recipeResults.count
            
        } catch {
            print("Failed to decode recipe: \(error.localizedDescription)")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBrowseScreen" {
            let browseScreen = segue.destination as! ExploreViewController
            browseScreen.recipes = recipes
            browseScreen.totalCards = count
        }
    }
}

