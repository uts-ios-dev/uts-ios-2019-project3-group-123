//
//  ViewController.swift
//  FoodTinder
//
//  Created by Alex Lin on 15/5/19.
//  Copyright © 2019 Alex Lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var loadingLabel: UILabel!
    
    var recipes: [Recipe] = []
    var count: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Hides navigation controller bar to only display back button
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    // Call API once when app loads.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadRecipesFromAPI()
    }
    
    // Activate the browser button only when the loading label is hidden
    @IBAction func browseRecipesBtn(_ sender: Any) {
        if loadingLabel.isHidden {
            performSegue(withIdentifier: "toBrowseScreen", sender: self)
        }
    }
    
    // Sets recipes equal to the recipes returned from the api reponse.
    func loadRecipesFromAPI() {
        let recipesAPI = "https://www.food2fork.com/api/search?key=97bf208eae7b1c390b2e8907a434aa2f"
        
        // convert string url to type of URL
        guard let url = URL(string: recipesAPI) else { return }
        
        // pass url to make the api call
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // check if there is any data
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            
            do {
                let recipeResults = try decoder.decode(RecipeAPI.self, from: data) // decode the data following the structure in RecipeAI.
                
                self.recipes = recipeResults.recipes
                self.count = recipeResults.count
                
                // Allows the app to update UI on the main thread while inside another function.
                DispatchQueue.main.async {
                    self.loadingLabel.isHidden = true;
                }
                
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

