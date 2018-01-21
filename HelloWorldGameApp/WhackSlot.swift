//
//  WhackSlot.swift
//  HelloWorldGameApp
//
//  Created by Ashley Chu on 1/1/18.
//  Copyright © 2018 Ashley Chu. All rights reserved.
//


import SpriteKit
import UIKit

class WhackSlot: SKNode{
    
    let goodCharacter = "goodPig.png"
    let badCharacter = "EvilPig.png"
    
    var charNode: SKSpriteNode! //creates penguin
    
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint) { //creates holes
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite) // adds into game
        
        let cropNode = SKCropNode() //allows masking
        cropNode.position = CGPoint(x: 0, y: 15) //sets initial
        cropNode.zPosition = 1 // changes position
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: goodCharacter) //good sprite
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        
        charNode.xScale = 1
        charNode.yScale = 1
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        
        isVisible = true
        isHit = false
        
        if RandomInt(min: 0, max: 2) == 0 {
            charNode.texture = SKTexture(imageNamed: goodCharacter) //good sprite
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: badCharacter) //evil sprite
            charNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [unowned self] in
            self.hide()
        }
    }
    
    func hide() {
        if !isVisible { return }
        
        charNode.run(SKAction.moveBy(x: 0, y:-80, duration:0.05))
        isVisible = false
    }
    
    func hit() {
        isHit = true
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y:-80, duration:0.5)
        let notVisible = SKAction.run { [unowned self] in self.isVisible = false }
        charNode.run(SKAction.sequence([delay, hide, notVisible]))
    }
    
}

