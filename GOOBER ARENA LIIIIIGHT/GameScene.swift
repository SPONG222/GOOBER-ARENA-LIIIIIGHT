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
    var gooberHealth = 4
    var goober2Health = 4
    let goober = SKSpriteNode(imageNamed: "Dragondih")
    let goober2 = SKSpriteNode(imageNamed: "booger")
    let hb = SKShapeNode()
    var virtualController: GCVirtualController?
    
    // a map that can be loaded into the game
    let level1 = [
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 2, 0, 0,
        0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 2, 0, 0, 0, 0, 0,
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
    var props = [TileProperties]()
    var shootButton: SKSpriteNode!
    
    var shoots = [SKSpriteNode]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    let square = SKShapeNode()
    var rect = CGRect(x: 100, y: 100, width: 100, height: 100)
    
    override func didMove(to view: SKView) {
        scene?.anchorPoint = .zero
        scene?.size = CGSize(width: 600, height: 800)
        
        goober.position = CGPoint(x: size.width / 2 - 200, y: size.height / 2)
        goober.zPosition = 10
        goober.setScale(0.15)
        addChild(goober)
        
        goober2.position = CGPoint(x: size.width / 2 + 200, y: size.height / 2)
        goober2.zPosition = 10
        goober2.setScale(0.15)
        addChild(goober2)
        
        addChild(square)
        
        connectVirtualController()
        
        // generate the level from the array
        genLevel(levelin: level1)
        
        shootButton = SKSpriteNode(imageNamed: "button") // or use a shape/color node
        shootButton.name = "button"
        shootButton.position = CGPoint(x: size.width / 9, y: size.height / 2 + 50)

        shootButton.zPosition = 10
        addChild(shootButton)


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
            return "rocknew"
        } else if type == 2 {
            return "coolergrass"
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
                if(typeToImageName(type: levelin[i]) == "coolergrass") {
                    wall.setScale(0.2)
                } else {
                    wall.setScale(1.0)
                }
                wall.zPosition = 8
                level.append(wall)
                
                let properties = TileProperties(type: typeToImageName(type: levelin[i]))
                props.append(properties)
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
            goober.position.x += 1.5
            goober.zRotation = 0.0
        }
        
        if px <= -0.5 {
            goober.position.x -= 1.5
            goober.zRotation = 3.14
        }
        
        if p2x >= 0.5 {
            goober2.position.x += 1.5
            goober2.zRotation = 0.0
        }
        
        if p2x <= -0.5 {
            goober2.position.x -= 1.5
            goober2.zRotation = 3.14
        }
        
        py = CGFloat((virtualController?.controller?.extendedGamepad?.leftThumbstick.yAxis.value)!)
        p2y = CGFloat((virtualController?.controller?.extendedGamepad?.rightThumbstick.yAxis.value)!)
        
        if py >= 0.5 {
            goober.position.y += 1.5
            goober.zRotation = 0.5 * 3.14
        }
        
        if py <= -0.5 {
            goober.position.y -= 1.5
            goober.zRotation = 1.5 * 3.14
        }
        
        if p2y >= 0.5 {
            goober2.position.y += 1.5
            goober2.zRotation = 0.5 * 3.14
        }
        
        if p2y <= -0.5 {
            goober2.position.y -= 1.5
            goober2.zRotation = 1.5 * 3.14
        }
        
        playerCollisions()
    }
    
    func playerCollisions() {
        for i in 0..<level.count {
            if(props[i].type == "rocknew") {
                if(BoxCollision(aPos: CGPoint(x: goober.position.x - 12, y: goober.position.y - 12), aSize: CGSize(width: 24, height: 24), bPos: level[i].position, bSize: level[i].size)) {
                    if(py <= -0.5) { goober.position.y += 1.5 }
                    if(py >= 0.5) { goober.position.y -= 1.5 }
                    if(px <= -0.5) { goober.position.x += 1.5 }
                    if(px >= 0.5) { goober.position.x -= 1.5 }
                }
                
                if(BoxCollision(aPos: CGPoint(x: goober2.position.x - 12, y: goober2.position.y - 12), aSize: CGSize(width: 24, height: 24), bPos: level[i].position, bSize: level[i].size)) {
                    if(p2y <= -0.5) { goober2.position.y += 1.5 }
                    if(p2y >= 0.5) { goober2.position.y -= 1.5 }
                    if(p2x <= -0.5) { goober2.position.x += 1.5 }
                    if(p2x >= 0.5) { goober2.position.x -= 1.5 }
                }
            }
        }
        
        let bufferX: CGFloat = -20
        let bufferY: CGFloat = -20

        let minX: CGFloat = 20.0 + bufferX
        let maxX: CGFloat = 580.0 - bufferX
        let minY: CGFloat = 280.0 + bufferY
        let maxY: CGFloat = 520.0 - bufferY

        goober.position.x = min(max(goober.position.x, minX), maxX)
        goober.position.y = min(max(goober.position.y, minY), maxY)

        goober2.position.x = min(max(goober2.position.x, minX), maxX)
        goober2.position.y = min(max(goober2.position.y, minY), maxY)
    }
    
    func projectileCollisions() {
        for i in (0..<shoots.count).reversed() {
            let shoot = shoots[i]
            
            if BoxCollision(aPos: CGPoint(x: goober2.position.x - 12, y: goober2.position.y - 12),aSize: CGSize(width: 40, height: 40),bPos:shoot.position, bSize: shoot.size) {
                goober2Health -= 1
               // goober2HealthLabel.text = "P2 HP: \(goober2Health)"
                shoot.removeFromParent()
                shoots.remove(at: i)
                
                if goober2Health <= 0 {
                    print("Goober 2 is dead")
                    goober2.removeFromParent()
                    
                }
            }
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
//        print("Goober 1 Position: \(goober.position)")
//        print("Goober 2 Position: \(goober2.position)")
        updatePlayers()
        projectileCollisions()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if atPoint(location) == shootButton {
            let shooter = Shoot()
            shoots.append(shooter.shootBullet(from: goober, in: self, at: location))
        }
    }


}
