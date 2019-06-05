//
//  Extensions.swift
//  FoodTinder
//
//  Created by Alex Lin on 19/5/19.
//  Copyright © 2019 Alex Lin. All rights reserved.
//

import UIKit

//Extension for CGPoint
//To get the difference between 2 CGPoints.
extension CGPoint {
    func sub(target: CGPoint) -> CGPoint {
        return CGPoint(x: self.x - target.x, y: self.y - target.y)
    }

    func add(target: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + target.x, y: self.y + target.y)
    }
}

//Extension for UIColor
extension UIColor {
    
    //To get a new color based on old color by just change 1 or more components.
    func to(red: CGFloat? = nil, green: CGFloat? = nil, blue: CGFloat? = nil, alpha: CGFloat? = nil) -> UIColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        r = red ?? r
        g = green ?? g
        b = blue ?? b
        a = alpha ?? a
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
