//
//  SavedRecipesTableViewController.swift
//  FoodTinder
//
//  Created by Sami Khalil on 22/5/19.
//  Copyright © 2019 Alex Lin. All rights reserved.
//

import UIKit

class SavedRecipesTableViewController: UITableViewController {
    
    private var savedRecipes: [SavedRecipe]? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        savedRecipes = CoreDataManager.retreive()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedRecipes?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SavedListCell", for: indexPath) as? SavedListCell, let recipes = savedRecipes, let imageName = recipes[indexPath.row].imageName {
            cell.nameLabel.text = recipes[indexPath.row].name
            cell.imageView?.image = UIImage(named: imageName)
            return cell
        }

        return UITableViewCell()
    }

}
