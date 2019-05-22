//
//  Recipe.swift
//  FoodTinder
//
//  Created by Alex Lin on 19/5/19.
//  Copyright © 2019 Alex Lin. All rights reserved.
//

import Foundation

class Recipe {
    var imageName: String
    var name: String
    var content: String
    var rate: Double
    var type: String
    var author: String
    var index: Int
    var isLiked: Bool?
    
    init(imageName: String, name: String, index: Int){
        self.imageName = imageName
        self.name = name
        self.content = "Content demo text"
        self.rate = 3
        self.type = "Ausie"
        self.author = "Alex"
        self.index = index
    }
}
