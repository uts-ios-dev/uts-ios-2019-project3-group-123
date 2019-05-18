//
//  ExploreViewController.swift
//  FoodTinder
//
//  Created by Alex Lin on 18/5/19.
//  Copyright © 2019 Alex Lin. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {

    @IBOutlet weak var Card: UIView!
    @IBOutlet weak var ThumbView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        guard let card = sender.view else { return; }
        let point = sender.translation(in: view)
        let offsetX = card.center.x - view.center.x

        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        let scale = 1 - abs(offsetX/view.frame.width)/2
        card.transform = CGAffineTransform(rotationAngle: .pi * offsetX / (8 * view.center.x)).scaledBy(x: scale, y: scale)
        
        if offsetX > 0 {
            ThumbView.image = UIImage(named: "Nice")
            ThumbView.tintColor = UIColor.green
        } else {
            ThumbView.image = UIImage(named: "Bad")
            ThumbView.tintColor = UIColor.red
        }
        
        ThumbView.alpha = abs(offsetX)/view.center.x
        
        if sender.state == UIGestureRecognizer.State.ended {
            
            let offZone: CGFloat = 0.3
            if card.center.x < view.center.x * offZone {
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: -self.view.center.x, y: card.center.y + 75)
                    card.transform = CGAffineTransform(rotationAngle: .pi / -4).scaledBy(x: 0.5, y: 0.5)
                }
            } else if card.center.x > view.center.x * (2-offZone) {
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: self.view.center.x * 3, y: card.center.y + 75)
                    card.transform = CGAffineTransform(rotationAngle: .pi / 4).scaledBy(x: 0.5, y: 0.5)
                }
            } else {
                resetCard()
            }
        }
    }
    
    @IBAction func reset(_ sender: UIButton) {
        resetCard()
    }
    func resetCard(){
        UIView.animate(withDuration: 0.2) {
            self.Card.center = self.view.center
            self.ThumbView.alpha = 0
            self.Card.transform = .identity
        }
    }
}
