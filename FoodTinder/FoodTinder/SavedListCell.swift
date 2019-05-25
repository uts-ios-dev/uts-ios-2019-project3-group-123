//
//  SavedListCell.swift
//  FoodTinder
//
//  Created by Zachary Simone on 26/5/19.
//  Copyright © 2019 Alex Lin. All rights reserved.
//

import UIKit

class SavedListCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var recipeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear 
    }
}
