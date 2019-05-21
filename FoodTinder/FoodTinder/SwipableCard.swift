//
//  SwipableCard.swift
//  FoodTinder
//
//  Created by Alex Lin on 19/5/19.
//  Copyright © 2019 Alex Lin. All rights reserved.
//

import UIKit

enum SwipeDirection: Int {
    case left = -1, none, right
    //The UIColor value
    var color: UIColor {
        switch self {
        case .left:  return UIColor.red
        case .none: return UIColor.lightGray
        case .right:return UIColor.green
        }
    }
}

class SwipableCard: UIView {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var thumbView: UIImageView!
    
    static var currentIndex: Int = 0
    static var total: Int = 0
    let offZone: CGFloat = 0.3
    //The rotation when card is about to leave screen. PI/8 is 180/8 about 22.5 in degree
    let rotationOffScreen: CGFloat = .pi/8
    var leftEnd: CGPoint = CGPoint.zero
    var rightEnd: CGPoint = CGPoint.zero
    var offset: CGPoint = CGPoint.zero
    var screenCenter: CGPoint = CGPoint.zero
    var index: Int = 0
    var standardSize: CGSize = CGSize.zero
    
    var lastCard: SwipableCard?
    var nextCard: SwipableCard?

    override func awakeFromNib() {
        self.layer.cornerRadius = 15
        self.backgroundColor = UIColor.black
        //imageView.layer.cornerRadius = 15
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panCard(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
    
    func loadContent(recipe: Recipe){
        imageView.image = UIImage(named: recipe.imageName)
        title.text = recipe.name
        index = recipe.index
        if let parent = self.superview {
            screenCenter = parent.center
        }else{
            screenCenter = self.center
        }
        leftEnd = CGPoint(x: -screenCenter.x, y: screenCenter.y)
        rightEnd = CGPoint(x: screenCenter.x * 3, y: screenCenter.y)
        standardSize = CGSize(width: screenCenter.x * 1.6, height: screenCenter.y * 1.6)
    }
    
    @objc func panCard(_ sender: UIPanGestureRecognizer){
        guard let card = sender.view else { return; }
        let point = sender.translation(in: self.superview)
        offset = card.center.sub(target: screenCenter)
        card.center = card.center.add(target: point)
        
        sender.setTranslation(CGPoint.zero, in: self.superview)
        
        let scale = 1 - abs(offset.x*0.5/screenCenter.x)*0.5
        card.transform = CGAffineTransform(rotationAngle: rotationOffScreen * offset.x / screenCenter.x).scaledBy(x: scale, y: scale)

        if offset.x > 0 {
            //thumbView.image = UIImage(named: "Nice")
            //thumbView.tintColor = UIColor.green
            self.backgroundColor = UIColor.black.to(green: abs(offset.x*0.5/screenCenter.x))
        } else {
            //thumbView.image = UIImage(named: "Bad")
            //thumbView.tintColor = UIColor.red
            self.backgroundColor = UIColor.black.to(red: abs(offset.x*0.5/screenCenter.x))
        }

        //thumbView.alpha = abs(offset.x)/screenCenter.x
        self.alpha = 1 - abs(offset.x)*0.5/screenCenter.x

        if sender.state == UIGestureRecognizer.State.ended {
            
            if card.center.x < screenCenter.x * offZone {
                swipe(.left)
            } else if card.center.x > screenCenter.x * (2-offZone) {
                swipe(.right)
            } else {
                back()
            }
        }
    }
    
    func swipe(_ direction: SwipeDirection){
        let goal = screenCenter.add(target: CGPoint(x: CGFloat(direction.rawValue) * 2 * screenCenter.x, y: 0))
        UIView.animate(withDuration: 0.3) {
            self.center = goal.add(target: CGPoint(x: 0, y: 75))
            self.transform = CGAffineTransform(rotationAngle: self.rotationOffScreen * 2 * CGFloat(direction.rawValue)).scaledBy(x: 0.5, y: 0.5)
            self.backgroundColor = direction.color
        }
    }
    
    func back(){
        UIView.animate(withDuration: 0.2) {
            self.center = self.screenCenter
            //self.thumbView.alpha = 0
            self.alpha = 1
            self.backgroundColor = UIColor.black
            self.transform = .identity
        }
    }
    
    func setLastCard(card: SwipableCard){
        lastCard = card
        card.nextCard = self
        setIndex(index: card.index + 1)
        //card.nextCard(self)
    }
    
    func setNextCard(card: SwipableCard){
        nextCard = card
    }
    
    func moveUp(){
        if index > 0 {
            index -= 1
            setIndex(index: index)
        }
    }
    
    func setIndex(index: Int){
//        UIView.animate(withDuration: 0.2) {
            self.frame.size.width = self.standardSize.width - CGFloat(index * 10)
            self.frame.size.height = self.standardSize.height - CGFloat(index * 10)
            self.center = self.screenCenter.add(target: CGPoint(x: 0, y: CGFloat(index * 10)))
            self.alpha = 1 - CGFloat(index) * 0.2
//        }
    }
}
