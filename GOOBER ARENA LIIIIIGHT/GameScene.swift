//
//  GameScene.swift
//  GOOBER ARENA LIIIIIGHT
//
//  Created by Kai Altschuler on 4/24/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    let square = SKShapeNode()
    let rect = CGRect(x: 100, y: 100, width: 100, height: 100)
    
    override func sceneDidLoad() {
        
        square.path = CGPath(rect: rect, transform: nil)
        square.fillColor = .blue
        square.strokeColor = .black
        square.lineWidth = 3
        
        addChild(square)
        
        self.lastUpdateTime = 0
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
        
        print("boi")
        square.zRotation += 5.0 * CGFloat(dt)
    }
}
