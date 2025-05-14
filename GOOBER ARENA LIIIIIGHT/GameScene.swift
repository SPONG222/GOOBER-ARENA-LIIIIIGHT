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
    let gooberHealthLabel = SKLabelNode()
    let goober2HealthLabel = SKLabelNode()
    var gooberHealth = 4
    var goober2Health = 4
    let goober = SKSpriteNode(imageNamed: "Dragondih")
    let goober2 = SKSpriteNode(imageNamed: "booger")
    var virtualController: GCVirtualController?
    
    var shootCooldown: TimeInterval = 0.5
        var lastShootTimeGoober: TimeInterval = -1
        var lastShootTimeGoober2: TimeInterval = -1
    
    // a map that can be loaded into the game
    let level1 = [
        0, 2, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 2, 0, 0,
        0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 2, 0, 0, 0, 0, 0,
        0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0,
        0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
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
    var shootButton2: SKSpriteNode!
    
    var shoots = [Shoot]()
    
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

        shootButton.zPosition = 15
        addChild(shootButton)

        gooberHealthLabel.text = "Goober 1 HP: \(gooberHealth)"
        gooberHealthLabel.fontSize = 40
        gooberHealthLabel.fontColor = .white
        gooberHealthLabel.position = CGPoint(x: 290, y: 500)
        gooberHealthLabel.zPosition = 20
        addChild(gooberHealthLabel)

        goober2HealthLabel.text = "Goober 2 HP: \(goober2Health)"
        goober2HealthLabel.fontSize = 40
        goober2HealthLabel.fontColor = .white
        goober2HealthLabel.position = CGPoint(x: 290, y: 280)
        goober2HealthLabel.zPosition = 20
        addChild(goober2HealthLabel)
        
        shootButton2 = SKSpriteNode(imageNamed: "button") // or use a shape/color node
        shootButton2.name = "button2"
        shootButton2.position = CGPoint(x: size.width - (size.width / 9), y: size.height / 2 + 50)

        shootButton2.zPosition = 15
        addChild(shootButton2)
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
            for j in 0..<level.count {
                if(props[j].type == "rocknew") {
                    if(BoxCollision(aPos: CGPoint(x: shoots[i].position.x - 4, y: shoots[i].position.y - 4), aSize: CGSize(width: 8, height: 8), bPos: level[j].position, bSize: level[j].size)) {
                        shoots[i].removeFromParent()
                    }
                }
            }
            
            if(shoots[i].owner == "goober" && gooberHealth > 0) {
                let shoot = shoots[i]
                
                if BoxCollision(aPos: CGPoint(x: goober2.position.x - 20, y: goober2.position.y - 20),aSize: CGSize(width: 40, height: 40),bPos:shoot.position, bSize: shoot.size) {
                    goober2Health -= 1
                   // goober2HealthLabel.text = "P2 HP: \(goober2Health)"
                    shoot.removeFromParent()
                    shoots.remove(at: i)
                    
                    if goober2Health <= 0 {
                        print("Goober 2 is dead")
                        goober2.removeFromParent()
                    }
                }
            } else {
                if(shoots[i].owner == "goober2" && goober2Health > 0) {
                    let shoot = shoots[i]
                    
                    if BoxCollision(aPos: CGPoint(x: goober.position.x - 20, y: goober.position.y - 20),aSize: CGSize(width: 40, height: 40),bPos: shoot.position, bSize: shoot.size) {
                        gooberHealth -= 1
                       // goober2HealthLabel.text = "P2 HP: \(goober2Health)"
                        shoot.removeFromParent()
                        shoots.remove(at: i)
                        
                        if gooberHealth <= 0 {
                            print("Goober 1 is dead")
                            goober.removeFromParent()
                            continue
                        }
                    }
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
        goober2HealthLabel.text = "Goober 2 HP: \(goober2Health >= 0 ? goober2Health : 0)"
        gooberHealthLabel.text = "Goober 1 HP: \(gooberHealth >= 0 ? gooberHealth : 0)"

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                let nodesAtPoint = nodes(at: location)

                for node in nodesAtPoint {
                    if node.name == "button" {
                        attemptShoot(player: "goober", shooter: goober, time: CACurrentMediaTime(), spriteName: "ball") // Use your bullet sprite name
                    } else if node.name == "button2" {
                        attemptShoot(player: "goober2", shooter: goober2, time: CACurrentMediaTime(), spriteName: "slime") // Use your bullet sprite name
                    }
                }
            }
        }

        func attemptShoot(player: String, shooter: SKSpriteNode, time: TimeInterval, spriteName: String) {
            if player == "goober" && (time - lastShootTimeGoober) >= shootCooldown {
                let newShoot = Shoot().shootBullet(from: shooter, in: self, at: shooter.position, pOwner: "goober", pSprite: spriteName)
                shoots.append(newShoot)
                lastShootTimeGoober = time
            } else if player == "goober2" && (time - lastShootTimeGoober2) >= shootCooldown {
                let newShoot = Shoot().shootBullet(from: shooter, in: self, at: shooter.position, pOwner: "goober2", pSprite: spriteName)
                shoots.append(newShoot)
                lastShootTimeGoober2 = time
            }
        }


}
