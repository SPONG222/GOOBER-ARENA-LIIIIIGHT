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
    
    let goober = SKSpriteNode(imageNamed: "Dragondih")
    let goober2 = SKSpriteNode(imageNamed: "Dragondih")
    var virtualController: GCVirtualController?
    
    // a map that can be loaded into the game
    let level1 = [
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0,
        0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    ]
    
    var px: CGFloat = 0
    var py: CGFloat = 0
    
    var p2x: CGFloat = 0
    var p2y: CGFloat = 0
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var level = [SKSpriteNode]()
    
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
        goober.setScale(0.3)
        addChild(goober)
        
        goober2.position = CGPoint(x: size.width / 2 + 200, y: size.height / 2)
        goober2.zPosition = 10
        goober2.setScale(0.3)
        addChild(goober2)
        
        connectVirtualController()
        
        // generate the level from the array
        genLevel(levelin: level1)
    }
    
    override func sceneDidLoad() {
        
        square.path = CGPath(rect: rect, transform: nil)
        square.fillColor = .blue
        square.strokeColor = .black
        square.lineWidth = 3
        
        self.lastUpdateTime = 0
    }
    
    // takes in a tile type and outputs the name of the corresponding image
    func typeToImageName(type: Int) -> String {
        if type == 1 {
            return "rock"
        } else if type == 2 {
            return "tree"
        } else {
            return ""
        }
    }
    
    // helper function to convert indexes into coordinates
    func indexToPoint(index: Int) -> CGPoint {
        
        // black magic math i came up with to convert a 1d index into 2d coords
        let x = (index % 19) * 32
        let ny = ((index - (index % 19)) / 19) * 32
        let y = 510 - ny
        
        return CGPoint(x: x, y: y)
    }
    
    // takes in a level and loads it into the game
    func genLevel(levelin: [Int]) {
        for i in 0..<levelin.count {
            if(levelin[i] != 0) {
                let wall = SKSpriteNode(imageNamed: typeToImageName(type: levelin[i]))
                wall.position = indexToPoint(index: i)
                print(wall.position)
                wall.anchorPoint = .zero
                wall.setScale(1.0)
                wall.zPosition = 8
                level.append(wall)
            }
        }
        
        for i in 0..<level.count {
            addChild(level[i])
        }
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
            goober.zRotation = 0.0
        }
        
        if px <= -0.5 {
            goober.position.x -= 3
            goober.zRotation = 3.14
        }
        
        if p2x >= 0.5 {
            goober2.position.x += 3
            goober2.zRotation = 0.0
        }
        
        if p2x <= -0.5 {
            goober2.position.x -= 3
            goober2.zRotation = 3.14
        }
        
        py = CGFloat((virtualController?.controller?.extendedGamepad?.leftThumbstick.yAxis.value)!)
        p2y = CGFloat((virtualController?.controller?.extendedGamepad?.rightThumbstick.yAxis.value)!)
        
        if py >= 0.5 {
            goober.position.y += 3
            goober.zRotation = 0.5 * 3.14
        }
        
        if py <= -0.5 {
            goober.position.y -= 3
            goober.zRotation = 1.5 * 3.14
        }
        
        if p2y >= 0.5 {
            goober2.position.y += 3
            goober2.zRotation = 0.5 * 3.14
        }
        
        if p2y <= -0.5 {
            goober2.position.y -= 3
            goober2.zRotation = 1.5 * 3.14
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
        
        print("Goober 1 Position: \(goober.position)")
        print("Goober 2 Position: \(goober2.position)")
        updatePlayers()
    }
}
