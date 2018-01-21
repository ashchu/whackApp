//
//  GameScene.swift
//  HelloWorldGameApp
//
//  Created by Ashley Chu on 1/1/18.
//  Copyright © 2018 Ashley Chu. All rights reserved.
//

import GameplayKit
import SpriteKit //positioning, blend modes, visual, nodes

class GameScene: SKScene {
    var gameScore: SKLabelNode! //visual score
    var score = 0 { // holds score as int
        didSet {
            gameScore.text = "Score: \(score)" //updates game score text
        }
    }
    
    var slots = [WhackSlot]() //new array w/ whack slots
    var popupTime = 0.85 //
    var numRounds = 0
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground") //sets background
        background.position = CGPoint(x: 512, y: 384) //centered
        background.blendMode = .replace //draws faster
        background.zPosition = -1
        addChild(background) //adds into scene
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster") //sets visual for gameScore
        gameScore.text = "Score: 0" //initial
        gameScore.position = CGPoint(x: 250, y: 50)//positioning
        gameScore.horizontalAlignmentMode = .right
        gameScore.fontSize = 48
        //print(score)
        addChild(gameScore)
        
        //rows of the holes
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) } // 0-4 <5, create slot at specific position
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
            self.createEnemy()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let tappedNodes = nodes(at: location)
            
            for node in tappedNodes {
                if node.name == "charFriend" {
                    // they shouldn't have whacked this penguin
                    let whackSlot = node.parent!.parent as! WhackSlot
                    if !whackSlot.isVisible { continue }
                    if whackSlot.isHit { continue }
                    
                    whackSlot.hit()
                    score -= 5
                    
                    run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion:false)) //sound
                } else if node.name == "charEnemy" {
                    // they should have whacked this one
                    let whackSlot = node.parent!.parent as! WhackSlot
                    if !whackSlot.isVisible { continue }
                    if whackSlot.isHit { continue }
                    
                    whackSlot.charNode.xScale = 0.85
                    whackSlot.charNode.yScale = 0.85
                    
                    whackSlot.hit()
                    score += 1
                    
                    run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion:false)) //sound
                }
            }
        }
    }
    
    func createSlot(at position: CGPoint) { //creates "slot" (whackslot)
        let slot = WhackSlot()
        slot.configure(at: position) //configures at x
        addChild(slot) //adds into scene
        slots.append(slot) //adds into slots array
    }
    
    func createEnemy() {
        numRounds += 1
        
        if numRounds >= 30 {
            for slot in slots {
                slot.hide()
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            
            return
        }
        
        popupTime *= 0.991
        
        slots = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: slots) as! [WhackSlot]
        slots[0].show(hideTime: popupTime)
        
        if RandomInt(min: 0, max: 12) > 4 { slots[1].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 8 {  slots[2].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 10 { slots[3].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 11 { slots[4].show(hideTime: popupTime)  }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = RandomDouble(min: minDelay, max: maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [unowned self] in
            self.createEnemy()
        }
    }
}


