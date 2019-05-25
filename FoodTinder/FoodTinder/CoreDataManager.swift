//
//  CoreDataManager.swift
//  FoodTinder
//
//  Created by Zachary Simone on 26/5/19.
//  Copyright © 2019 Alex Lin. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    /// Public helper method to save a new result to CoreData
    /// Parameters: Takes a name `String` and score `Double`
    static func save(_ recipe: Recipe) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let savedRecipe = SavedRecipe(context: context)
        savedRecipe.author = recipe.author
        savedRecipe.content = recipe.content
        savedRecipe.imageName = recipe.imageName
        savedRecipe.name = recipe.name
        savedRecipe.rate = recipe.rate
        savedRecipe.type = recipe.type
        
        appDelegate.saveContext()
    }
    
    /// Public helper method to retreive all high score values
    /// Data is returned as an optional array of `Recipe` objects
    static func retreive() -> [SavedRecipe]? {
        
        // Check for existence of `appDelegate`
        // Return early if it doesn't exist
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        /// Create fetch request for entity "Recipe"
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
        
        // Attempt to fetch the data
        // If we can't, return nil
        // This `nil` value will be handled by the code that's requesting the Core Data values
        do {
            return try appDelegate.persistentContainer.viewContext.fetch(fetch) as? [SavedRecipe]
        } catch {
            return nil
        }
    }
}

