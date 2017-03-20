//
//  GameScene.swift
//  WhaleFree
//
//  Created by Samantha Morrison on 06/03/17.
//  Copyright © 2017 Samantha Morrison. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let background = SKSpriteNode(imageNamed: "backgroundImage")
    
    var score = 0
    var health = 3
    var gameOver : Bool?
    let maxNumberOfWhales = 10
    var currentNumberOfWhales : Int?
    var timeBetweenWhales : Double?
    var moverSpeed = 5.0
    let moveFactor = 1.0
    var timeNow : NSDate?
    var nextTime : NSDate?
    var gameOverLabel : SKLabelNode?
    var healthLabel : SKLabelNode?
    
    
    override func didMove(to view: SKView) {
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(createWhale),
                SKAction.wait(forDuration: 1.0)])))
        
        initializeValues()
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }

    
    func initializeValues(){
        self.removeAllChildren()
        
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background)
        
        score = 0
        gameOver = false
        currentNumberOfWhales = 0
        timeBetweenWhales = 1.0
        moverSpeed = 5.0
        health = 3
        nextTime = NSDate()
        timeNow = NSDate()
        
        healthLabel = SKLabelNode(fontNamed:"System")
        healthLabel?.text = "Health: \(health)"
        healthLabel?.fontSize = 30
        healthLabel?.fontColor = SKColor.black
        healthLabel?.position = CGPoint(x:self.frame.minX + 80, y:(self.frame.minY + 100));
        
        self.addChild(healthLabel!)
    }
    
    func createWhale(){
        let whale = SKSpriteNode(imageNamed: "whale")
        whale.name = "whale"
        whale.position = CGPoint(x: frame.size.width + whale.size.width/2,
                                 y: frame.size.height * random(min: 0, max: 1))
        addChild(whale)
        whale.run(SKAction.moveBy(x: -size.width - whale.size.width, y: 0.0,
                                  duration: TimeInterval(random(min: 1, max: 2))))
    }
    
    func checkIfWhalesReachEnd(){
        for child in self.children {
            if(child.position.x == 0){
                self.removeChildren(in: [child])
                currentNumberOfWhales?-=1
                health -= 1
            }
        }
    }
    
    func checkIfGameIsOver(){
        if (health <= 0 && gameOver == false){
            self.removeAllChildren()
            showGameOverScreen()
            gameOver = true
        }
    }
    
    func showGameOverScreen(){
        gameOverLabel = SKLabelNode(fontNamed:"System")
        gameOverLabel?.text = "Game Over! Score: \(score)"
        gameOverLabel?.fontColor = SKColor.red
        gameOverLabel?.fontSize = 65;
        gameOverLabel?.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        self.addChild(gameOverLabel!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = (touch as! UITouch).location(in: self)
            if let theName = self.atPoint(location).name {
                if theName == "whale" {
                    self.removeChildren(in: [self.atPoint(location)])
                    currentNumberOfWhales?-=1
                    score+=1
                    }
                }
                if (gameOver!==true){
                    initializeValues()
                }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        healthLabel?.text="Health: \(health)"
        if(health < 2){
            healthLabel?.fontColor = SKColor.red
        }
        
        timeNow = NSDate()
        if (currentNumberOfWhales! < maxNumberOfWhales &&
            timeNow!.timeIntervalSince1970 > nextTime!.timeIntervalSince1970 &&
            health > 0){
            
            nextTime = timeNow?.addingTimeInterval(TimeInterval(timeBetweenWhales!))
            let newX = Int(arc4random()%1024)
            let newY = Int(self.frame.height+10)
            _ = CGPoint(x:newX,y:newY)
            
            createWhale()
            
            moverSpeed = moverSpeed/moveFactor
            timeBetweenWhales = timeBetweenWhales!/moveFactor
        }
        checkIfWhalesReachEnd()
        checkIfGameIsOver()
    }
}
