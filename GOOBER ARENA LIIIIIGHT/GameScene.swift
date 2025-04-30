//
//  GameScene.swift
//  GOOBER ARENA LIIIIIGHT
//
//  Created by Kai Altschuler on 4/24/25.
//

import SpriteKit
import GameplayKit
import Foundation
import GameController

class GameScene: SKScene {
    
    let goober = SKSpriteNode(imageNamed: "goooober")
    let goober2 = SKSpriteNode(imageNamed: "goooober")
    var virtualController: GCVirtualController?
    
    var px: CGFloat = 0
    var py: CGFloat = 0
    
    var p2x: CGFloat = 0
    var p2y: CGFloat = 0
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    let square = SKShapeNode()
    let rect = CGRect(x: 100, y: 100, width: 100, height: 100)
    
    override func didMove(to view: SKView) {
        scene?.anchorPoint = .zero
        scene?.size = CGSize(width: 600, height: 800)
        
        goober.position = CGPoint(x: size.width / 2 - 200, y: size.height / 2)
        goober.zPosition = 10
        goober.setScale(0.03)
        addChild(goober)
        
        goober2.position = CGPoint(x: size.width / 2 +s 200, y: size.height / 2)
        goober2.zPosition = 10
        goober2.setScale(0.03)
        addChild(goober2)
        
        connectVirtualController()
    }
    
    override func sceneDidLoad() {
        
        square.path = CGPath(rect: rect, transform: nil)
        square.fillColor = .blue
        square.strokeColor = .black
        square.lineWidth = 3
        
//        addChild(square)
        
        self.lastUpdateTime = 0
    }
    
    func connectVirtualController() {
        let controllerConfig = GCVirtualController.Configuration()
        controllerConfig.elements = [GCInputLeftThumbstick, GCInputRightThumbstick]
        
        let controller = GCVirtualController(configuration: controllerConfig)
        controller.connect()
        virtualController = controller
    }
    
    func updatePlayers() {
        // Joystick input
        px = CGFloat((virtualController?.controller?.extendedGamepad?.leftThumbstick.xAxis.value)!)
        p2x = CGFloat((virtualController?.controller?.extendedGamepad?.rightThumbstick.xAxis.value)!)
        
        if px >= 0.5 {
            goober.position.x += 3
        }
        
        if px <= -0.5 {
            goober.position.x -= 3
        }
        
        if p2x >= 0.5 {
            goober2.position.x += 3
        }
        
        if p2x <= -0.5 {
            goober2.position.x -= 3
        }
        
        py = CGFloat((virtualController?.controller?.extendedGamepad?.leftThumbstick.yAxis.value)!)
        p2y = CGFloat((virtualController?.controller?.extendedGamepad?.rightThumbstick.yAxis.value)!)
        
        if py >= 0.5 {
            goober.position.y += 3
        }
        
        if py <= -0.5 {
            goober.position.y -= 3
        }
        
        if p2y >= 0.5 {
            goober2.position.y += 3
        }
        
        if p2y <= -0.5 {
            goober2.position.y -= 3
        }
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
        
        updatePlayers()
    }
}
