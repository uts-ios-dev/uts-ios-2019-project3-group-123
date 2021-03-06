//
//  SwipableCard.swift
//  FoodTinder
//
//  Created by Alex Lin on 19/5/19.
//  Copyright © 2019 Alex Lin. All rights reserved.
//

import UIKit

//Cards state, normal is the top one, next is the one after top one
//end is a back one which hide from user, only for backup.
//left or right is the one when the card is swiped away.
enum CardState: Int {
    case left = -1, normal, right, next, end
    
    //The UIColor value
    var color: UIColor {
        switch self {
        case .left:     return UIColor.red
        case .normal:   return UIColor.black
        case .right:    return UIColor.green
        case .next:     return UIColor.black
        case .end:      return UIColor.black
        }
    }
}

//Pop is when you exploring the new cards.
//Back is when you regret and get swiped cards back to the stack. Currently not used.
enum ShiftWay: Int {
    case pop, back, none
}

class SwipableCard: UIView {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var thumbView: UIImageView!
    @IBAction func MoreInfo(_ sender: UIButton) {
        //performSegue(withIdentifier: "toIngredientsScreen", sender: self)
    }
    
    static var total: Int = 4
    static var currentTop: SwipableCard?
    static var currentEnd: SwipableCard? {
        get { return SwipableCard.currentTop?.nextCard?.nextCard }
    }
    static var recipes: [Recipe]?

    //Constances
    let offZone: CGFloat = 0.2  //The area percentage to the width.
    let offScreenRotation: CGFloat = .pi/8  //The rotation when card is about to leave screen. PI/8 is 180/8 about 22.5 in degree
    let offScreenAlpha: CGFloat = 0.8   //The alpha value when the card is on edge of screen
    let offScreenScale: CGFloat = 0.8   //The scale value when the card is on edge of screen
    let nextCardScale: CGFloat = 0.8    //The size of next card
    let animDuration: TimeInterval = 0.2    //The duration of the animation
    
    var screenCenter: CGPoint {
        get { return self.superview?.center ?? self.center }
    }
    var leftEnd: CGPoint {
        get { return CGPoint(x: -screenCenter.x, y: screenCenter.y) }
    }
    var rightEnd: CGPoint {
        get { return CGPoint(x: screenCenter.x * 3, y: screenCenter.y) }
    }
    var standardSize: CGSize {
        get {
            return CGSize(width: screenCenter.x * 1.9, height: screenCenter.y * 1.6)
        }
    }
    var offset: CGPoint = CGPoint.zero
    var index: Int = 0 {
        didSet{
            self.layer.zPosition = CGFloat(SwipableCard.total - index - 1)
            setActive(to: index == 0)
        }
    }
    
    var recipe: Recipe?
    var lastCard: SwipableCard?
    var nextCard: SwipableCard?
    var debugMode: Bool = false
        
    override func awakeFromNib() {
        self.layer.cornerRadius = 15
        self.backgroundColor = UIColor.black
        imageView.layer.cornerRadius = 15
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panCard(_:)))
        self.addGestureRecognizer(gesture)
        self.isUserInteractionEnabled = false
    }
    
    //Load content from the recipe
    func loadContent(recipe: Recipe){
        self.recipe = recipe
        print("recipe \(recipe.title)")
        
        recipe.loadImage(imageView: imageView)
        
        recipe.getIngredients() { [weak self] ingredients in
            print("Ingredients added")
        }
        
        title.text = recipe.title
        //index = recipe.index
    }
    
    //Resize card when it is loaded to the scene
    func resize(){
        self.frame.size.width = self.standardSize.width
        self.frame.size.height = self.standardSize.height
    }
    
    //Accept the pan gesture
    @objc func panCard(_ sender: UIPanGestureRecognizer){
        guard let card = sender.view else { return; }
        
        //Get the drag offset and cards center
        let point = sender.translation(in: self.superview)
        offset = card.center.sub(target: screenCenter)
        card.center = card.center.add(target: point)
        
        sender.setTranslation(CGPoint.zero, in: self.superview)
        
        //Cards' scale based on the distance to center
        let scale = offsetMap(offScreenScale)
        card.transform = CGAffineTransform(rotationAngle: offScreenRotation * offset.x / screenCenter.x).scaledBy(x: scale, y: scale)
        
        //Display the thumb base on the direction the card is swiped.
        if offset.x > 0 {
            thumbView.image = UIImage(named: "Nice")
            thumbView.tintColor = UIColor.green
            self.backgroundColor = UIColor.black.to(green: abs(offset.x*0.5/screenCenter.x))
        } else {
            thumbView.image = UIImage(named: "Bad")
            thumbView.tintColor = UIColor.red
            self.backgroundColor = UIColor.black.to(red: abs(offset.x*0.5/screenCenter.x))
        }
        
        //Change the alpha when swipe away the card.
        thumbView.alpha = abs(offset.x)/screenCenter.x
        self.alpha = offsetMap(offScreenAlpha)

        if sender.state == UIGestureRecognizer.State.ended {
            
            //When the gesture is done, move the card back to center or swipe away depends on
            //the card's end position
            if card.center.x < screenCenter.x * offZone {
                swipe(.left)
            } else if card.center.x > screenCenter.x * (2-offZone) {
                swipe(.right)
                //markCardAsLiked()
            } else {
                back()
            }
        }
    }
    
    //Get the bottom car.
    func getBottomCard() -> SwipableCard? {
        return SwipableCard.currentTop?.nextCard?.nextCard
    }
    
    //Get the offset and map to the value that needed for setting alpha and scale
    func offsetMap(_ value: CGFloat) -> CGFloat {
        return 1 - abs(offset.x*(1-value)/screenCenter.x)
    }
    
    //Swipe to left or right.
    func swipe(_ direction: CardState){
        self.recipe?.isLiked = direction == .right
        UIView.animate(withDuration: animDuration) {
            self.shift(.pop)
        }
    }
    
    //Regret when card is swiped away. Currently not used.
    func regret() {
        UIView.animate(withDuration: animDuration) {
            self.shift(.back)
        }
    }
    
    //Back to center point.
    func back(){
        UIView.animate(withDuration: animDuration) {
            self.shift(.none)
        }
    }
    
    //Either to pop the card out, or get the card back to stack.
    func shift(_ way: ShiftWay){
        if way == .back {
            setIndex(index: (index + 1) % SwipableCard.total)
            if self.nextCard?.index == self.index {
                self.nextCard?.shift(way)
            }
            if index == SwipableCard.total - 1 {
                self.superview?.bringSubviewToFront(self)
            }
        } else if way == .pop{
            if index == SwipableCard.total - 1 {
                self.superview?.sendSubviewToBack(self)
            }
            setIndex(index: (SwipableCard.total + index - 1) % SwipableCard.total)
            if self.lastCard?.index == self.index {
                self.lastCard?.shift(way)
            }
        } else {
            if self.index == 0 {
                self.setState(state: .normal)
            }
            return
        }
        
        //Load the recipe to the bottom card.
        if self.index == 2 {
            if let id = self.lastCard?.recipe?.index {
                if let count = SwipableCard.recipes?.count {
                    loadContent(recipe: SwipableCard.recipes![(id + 1) % count])
                    //SwipableCard.currentEnd?.setIndex(index: 2)
                }
            }
        }
    }
    
    //Only the top card can be swiped.
    func setActive(to active: Bool = true){
        self.isUserInteractionEnabled = active
    }
    
    //Set the index of the card
    func setIndex(index: Int){
        self.index = index
        switch index {
        case 1:
            setState(state: .next)
        case 2:
            setState(state: .end)
        case 3:
            setState(state: recipe?.isLiked ?? false ? .right : .left)
        default:
            setState(state: .normal)
            SwipableCard.currentTop = self
        }
    }
    
    //Set the state of the card
    func setState(state: CardState) {
        switch state {
        case .left:
            animateCardAfterSwipe(state)
        case .right:
            animateCardAfterSwipe(state)
            markCardAsLiked()
        case .end:
            self.center = self.screenCenter
            self.thumbView.alpha = 0
            self.alpha = 0
            self.backgroundColor = state.color
            self.transform = CGAffineTransform(rotationAngle: 0).scaledBy(x: nextCardScale, y: nextCardScale)
        case .next:
            self.center = self.screenCenter
            self.thumbView.alpha = 0
            self.alpha = 1
            self.backgroundColor = state.color
            self.transform = CGAffineTransform(rotationAngle: 0).scaledBy(x: nextCardScale, y: nextCardScale)
        default:
            self.center = self.screenCenter
            self.thumbView.alpha = 0
            self.alpha = 1
            self.backgroundColor = state.color
            self.transform = .identity
        }
    }
    
    //Connect cards together to the listlink
    func setLastCard(card: SwipableCard){
        lastCard = card
        card.nextCard = self
    }
    
    //For debug purpose
    func debug(_ content: String){
        if debugMode {
            print(content)
        }
    }
    
    func enableDebug(){
        debugMode = true
    }
    
    //End value for animation.
    private func animateCardAfterSwipe(_ state: CardState) {
        let goal = screenCenter.add(target: CGPoint(x: CGFloat(state.rawValue) * 2 * screenCenter.x, y: 0))
        self.center = goal.add(target: CGPoint(x: 0, y: 75))
        self.transform = CGAffineTransform(rotationAngle: self.offScreenRotation * 2 * CGFloat(state.rawValue)).scaledBy(x: 0.5, y: 0.5)
        self.backgroundColor = state.color
        self.alpha = 0
    }
    
    //To save the card into savelist.
    private func markCardAsLiked() {
        guard let recipe = recipe else { return }
        CoreDataManager.save(recipe)
    }
}
