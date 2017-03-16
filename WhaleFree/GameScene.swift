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
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    
    override func sceneDidLoad() {

    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "backgroundImage")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background)
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(spawnWhale),
                SKAction.wait(forDuration: 1.0)])))
        
        /*var levelTimerLabel = SKLabelNode(fontNamed: "ArialMT")
        
        var levelTimerValue: Int = 30 {
            didSet {
                levelTimerLabel.text = "Time left: \(levelTimerValue)"
            }
        }
        levelTimerLabel.fontColor = SKColor.black
        levelTimerLabel.fontSize = 20
        levelTimerLabel.position = CGPoint(x: size.width/2, y: size.height/2 + 200)
        levelTimerLabel.text = "Time left: \(levelTimerValue)"
        addChild(levelTimerLabel)
        
        let wait = SKAction.wait(forDuration: 1.0)
        let block = SKAction.run({
            [unowned self] in
            
            if self.levelTimerValue > 0 {
                self.levelTimerValue -= 1
            }else{
                self.removeAction(forKey: "countdown")
            }
        })
        let sequence = SKAction.sequence([wait,block])
        
        run(SKAction.repeatForever(sequence), withKey: "countdown")*/
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func spawnWhale() {
        let whale = SKSpriteNode(imageNamed: "whale")
        whale.name = "whale"
        whale.position = CGPoint(x: frame.size.width + whale.size.width/2,
                                 y: frame.size.height * random(min: 0, max: 1))
        addChild(whale)
        whale.run(
            SKAction.moveBy(x: -size.width - whale.size.width, y: 0.0,
                             duration: TimeInterval(random(min: 1, max: 2))))
    }
    
    /*func levelCountdown(){
        levelTimerValue--
        levelTimerLabel.text = String(levelTimerValue)
    }*/

    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        if action(forKey: "countdown") != nil {removeAction(forKey: "countdown")}
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
