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
    // game objects
    let gooberHealthLabel = SKLabelNode()
    let goober2HealthLabel = SKLabelNode()
    var gooberHealth = 4
    var goober2Health = 4
    let goober = SKSpriteNode(imageNamed: "Dragondih")
    let goober2 = SKSpriteNode(imageNamed: "booger")
    var virtualController: GCVirtualController?
    var winText = SKLabelNode(fontNamed: "Arial")
    
    var mainMenuOpen = true
    
    let grassColor = UIColor(red: 0.2, green: 0.84, blue: 0.29, alpha: 1.0)
    let roofColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    let sandColor = UIColor(red: 0.98, green: 0.82, blue: 0.47, alpha: 1.0)
    
    // menu objects
    var mmTitle = SKLabelNode(text: "Goober Arena Light")
    var mmLevel1 = SKLabelNode(text: "Grassy Arena")
    var mmLevel2 = SKLabelNode(text: "Rooftop Arena")
    var mmLevel3 = SKLabelNode(text: "Desert Arena")
    
    var winButton = SKShapeNode()
    var winButtonText = SKLabelNode(fontNamed: "Arial")
    var back2menu = SKLabelNode(fontNamed: "Arial")
    
    var gameIsOver = false
    
    var shootCooldown: TimeInterval = 0.5
        var lastShootTimeGoober: TimeInterval = -1
        var lastShootTimeGoober2: TimeInterval = -1
    
    // a map that can be loaded into the game
    let level1 = [
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 2, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 2, 0,
        0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 2, 0, 0,
        0, 0, 2, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 2, 0, 0, 0, 0, 0,
        0, 0, 2, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 2, 0,
        2, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    ]
    
    let level2 = [
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 4,
        0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0,
        0, 0, 0, 4, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 4, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    ]
    
    let level3 = [
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 6, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 6, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 6, 0, 0,
        0, 0, 6, 0, 6, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 6, 1, 1, 1, 1, 1, 0, 0, 6, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 6, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 6, 0, 0, 0, 0, 0,
        0, 0, 6, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 6, 0,
        6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
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
    var rect = CGRect(x: 238, y: 350, width: 100, height: 40)
    
    override func didMove(to view: SKView) {
        scene?.anchorPoint = .zero
        scene?.size = CGSize(width: 600, height: 800)
        scene?.backgroundColor = grassColor
        
        goober.position = CGPoint(x: size.width / 2 - 200, y: size.height / 2)
        goober.zPosition = 10
        goober.setScale(0.15)
        addChild(goober)
        
        goober2.position = CGPoint(x: size.width / 2 + 200, y: size.height / 2)
        goober2.zPosition = 10
        goober2.setScale(0.15)
        addChild(goober2)
        
        connectVirtualController()
        
        // generate the level from the array
//        genLevel(levelin: level1)
        
        winButton.path = CGPath(rect: rect, transform: nil)
        winButton.fillColor = .gray
        winButton.strokeColor = .black
        winButton.lineWidth = 2
        winButton.zPosition = 20
        
//        addChild(winButton)
//        winButton.isHidden = true
        
        winButtonText.text = "Rematch"
        winButtonText.fontSize = 20
        winButtonText.fontColor = .white
        winButtonText.position = CGPoint(x: 290, y: 365)
        winButtonText.zPosition = 21
        
        addChild(winButtonText)
        winButtonText.isHidden = true
        
        back2menu.text = "Back to menu"
        back2menu.fontSize = 20
        back2menu.fontColor = .white
        back2menu.position = CGPoint(x: 290, y: 340)
        back2menu.zPosition = 21
        
//        addChild(back2menu)
        back2menu.isHidden = true
        
        mmTitle.text = "Goober Arena Light"
        mmTitle.fontSize = 38
        mmTitle.fontName = "Arial"
        mmTitle.fontColor = .white
        mmTitle.position = CGPoint(x: 300, y: 470)
        mmTitle.zPosition = 20
        addChild(mmTitle)
        
        mmLevel1.fontSize = 25
        mmLevel1.fontName = "Arial"
        mmLevel1.fontColor = .white
        mmLevel1.position = CGPoint(x: 300, y: 400)
        mmLevel1.zPosition = 20
        addChild(mmLevel1)
        
        mmLevel2.fontSize = 25
        mmLevel2.fontName = "Arial"
        mmLevel2.fontColor = .white
        mmLevel2.position = CGPoint(x: 300, y: 370)
        mmLevel2.zPosition = 20
        addChild(mmLevel2)
        
        mmLevel3.fontSize = 25
        mmLevel3.fontName = "Arial"
        mmLevel3.fontColor = .white
        mmLevel3.position = CGPoint(x: 300, y: 340)
        mmLevel3.zPosition = 20
        addChild(mmLevel3)
        
        shootButton = SKSpriteNode(imageNamed: "button") // or use a shape/color node
        shootButton.name = "button"
        shootButton.position = CGPoint(x: size.width / 9, y: size.height / 2 + 50)
        
        shootButton.zPosition = 15
        addChild(shootButton)
//Archer below
        gooberHealthLabel.text = "Goober 1 HP: \(gooberHealth)"
        gooberHealthLabel.fontName = "Arial"
        gooberHealthLabel.fontSize = 25
        gooberHealthLabel.fontColor = .white
        gooberHealthLabel.position = CGPoint(x: 290, y: 510)
        gooberHealthLabel.zPosition = 20
        addChild(gooberHealthLabel)

        goober2HealthLabel.text = "Goober 2 HP: \(goober2Health)"
        goober2HealthLabel.fontName = "Arial"
        goober2HealthLabel.fontSize = 25
        goober2HealthLabel.fontColor = .white
        goober2HealthLabel.position = CGPoint(x: 290, y: 280)
        goober2HealthLabel.zPosition = 20
        addChild(goober2HealthLabel)
        
        winText.text = ""
        winText.fontSize = 50
        winText.fontColor = .white
        winText.position = CGPoint(x: 290, y: 400);
        winText.zPosition = 25
        addChild(winText)
        //archer end
        shootButton2 = SKSpriteNode(imageNamed: "button") // or use a shape/color node
        shootButton2.name = "button2"
        shootButton2.position = CGPoint(x: size.width - (size.width / 9), y: size.height / 2 + 50)

        shootButton2.zPosition = 15
        addChild(shootButton2)
        
        setGameObjsHidden(hidden: true)
        setMenuObjsHidden(hidden: false)
    }
    
    // zach
    func destroyLevel() {
        for i in 0..<level.count {
            level[i].removeFromParent()
        }
        
        level = []
    }
    
    // zach
    func setMenuObjsHidden(hidden: Bool) {
        mmTitle.isHidden = hidden
        mmLevel1.isHidden = hidden
        mmLevel2.isHidden = hidden
        mmLevel3.isHidden = hidden
    }
    
    override func sceneDidLoad() {
        
        square.path = CGPath(rect: rect, transform: nil)
        square.fillColor = .blue
        square.strokeColor = .black
        square.lineWidth = 3
        
        self.lastUpdateTime = 0
    }
    
    // zach
    // takes in a tile type and outputs the name of the corresponding image
    func typeToImageName(type: Int) -> String {
        if type == 1 {
            return "rocknew"
        } else if type == 2 {
            return "coolergrass"
        } else if type == 3 {
            return "rooftop brick"
        } else if type == 4 {
            return "rooftop stain"
        } else if type == 5 {
            return "sand"
        } else if type == 6 {
            return "sand spot"
        } else {
            return ""
        }
    }
    
    // zach
    // helper function to convert indexes into coordinates
    func indexToPoint(index: Int) -> CGPoint {
        
        // black magic math i came up with to convert a 1d index into 2d coords
        let x = (index % 19) * 32
        let ny = ((index - (index % 19)) / 19) * 32
        let y = 510 - ny + 48
        
        return CGPoint(x: x, y: y)
    }
    
    // zach
    // this level code was ported from another project of mine: https://github.com/PancakeHat/leapform
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

    // zach
    func connectVirtualController() {
        let controllerConfig = GCVirtualController.Configuration()
        controllerConfig.elements = [GCInputLeftThumbstick, GCInputRightThumbstick]
        
        let controller = GCVirtualController(configuration: controllerConfig)
        controller.connect()
        virtualController = controller
    }
    
    // all of us contributed
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
    
    // zach
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
        
        // archer
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
    
    // zach
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
                //archer
                if BoxCollision(aPos: CGPoint(x: goober2.position.x - 20, y: goober2.position.y - 20),aSize: CGSize(width: 40, height: 40),bPos:shoot.position, bSize: shoot.size) {
                    goober2Health -= 1
                    shoot.removeFromParent()
                    shoots.remove(at: i)
                    
                    if goober2Health <= 0 {
                        print("Goober 2 is dead")
                        goober2.isHidden = true
                    }
                }
            } else {
                if(shoots[i].owner == "goober2" && goober2Health > 0) {
                    let shoot = shoots[i]
                    //archer
                    if BoxCollision(aPos: CGPoint(x: goober.position.x - 20, y: goober.position.y - 20),aSize: CGSize(width: 40, height: 40),bPos: shoot.position, bSize: shoot.size) {
                        gooberHealth -= 1
                        shoot.removeFromParent()
                        shoots.remove(at: i)
                        
                        if gooberHealth <= 0 {
                            print("Goober 1 is dead")
                            goober.isHidden = true
                            continue
                        }
                    }
                }
            }
        }
    }
    
    func mainMenu() {
        
    }
    
    // zach
    func setGameObjsHidden(hidden: Bool) {
        goober.isHidden = hidden
        goober2.isHidden = hidden

        shootButton.isHidden = hidden
        shootButton2.isHidden = hidden
        gooberHealthLabel.isHidden = hidden
        goober2HealthLabel.isHidden = hidden
        
        for i in 0..<level.count {
            level[i].isHidden = hidden
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
        
        if(!mainMenuOpen) {
            updatePlayers()
            projectileCollisions()
            goober2HealthLabel.text = "Goober 2 HP: \(goober2Health >= 0 ? goober2Health : 0)"
            gooberHealthLabel.text = "Goober 1 HP: \(gooberHealth >= 0 ? gooberHealth : 0)"
            
            if(!gameIsOver) {
                //archer
                if(gooberHealth <= 0) {
                    winText.text = "Goober 2 Wins"
                    gameIsOver = true
                    winButtonText.isHidden = false
                    back2menu.isHidden = false
                    winButton.isHidden = false
                }
                //archer
                if(goober2Health <= 0) {
                    print("test")
                    winText.text = "Goober 1 Wins"
                    gameIsOver = true
                    winButtonText.isHidden = false
                    back2menu.isHidden = false
                    winButton.isHidden = false
                }
            }
        } else {
            mainMenu()
        }

    }
    
    // zach
    func loadMapFromLevel(level: Int) {
        destroyLevel()
        
        if level == 1 {
            genLevel(levelin: level1)
            scene?.backgroundColor = grassColor
        } else if level == 2 {
            genLevel(levelin: level2)
            scene?.backgroundColor = roofColor
        } else if level == 3 {
            genLevel(levelin: level3)
            scene?.backgroundColor = sandColor
        }
        
        restartGame()
        setGameObjsHidden(hidden: false)
        setMenuObjsHidden(hidden: true)
        mainMenuOpen = false
        gameIsOver = false
    }
    
    // zach
    func restartGame() {
        print("restarting game...")
        
        winText.text = ""
        winButtonText.isHidden = true
        winButton.isHidden = true
        back2menu.isHidden = true
        
        goober.position = CGPoint(x: size.width / 2 - 200, y: size.height / 2)
        goober2.position = CGPoint(x: size.width / 2 + 200, y: size.height / 2)
        goober.isHidden = false
        goober2.isHidden = false
        
        gooberHealth = 4
        goober2Health = 4
        
        gameIsOver = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                let nodesAtPoint = nodes(at: location)
                
                if !mainMenuOpen {
                    for node in nodesAtPoint {
                        if node.name == "button" {
                            attemptShoot(player: "goober", shooter: goober, time: CACurrentMediaTime(), spriteName: "ball") // Use your bullet sprite name
                        }
                        
                        if node.name == "button2" {
                            attemptShoot(player: "goober2", shooter: goober2, time: CACurrentMediaTime(), spriteName: "slime") // Use your bullet sprite name
                        }
                        
                        if atPoint(location) == winButton && gameIsOver == true {
                            restartGame()
                        }
                        
                        if atPoint(location) == winButtonText && gameIsOver == true {
                            restartGame()
                        }
                        
                        if atPoint(location) == back2menu && gameIsOver == true {
                            scene?.backgroundColor = grassColor
                            destroyLevel()
                            restartGame()
                            setGameObjsHidden(hidden: true)
                            setMenuObjsHidden(hidden: false)
                            mainMenuOpen = true
                        }
                    }
                } else {
                    if atPoint(location) == mmLevel1 {
                        print("map 1")
                        loadMapFromLevel(level: 1)
                        
                    }
                        
                    if atPoint(location) == mmLevel2 {
                        print("map 2")
                        loadMapFromLevel(level: 2)
                        
                    }
                        
                    if atPoint(location) == mmLevel3 {
                        print("map 3")
                        loadMapFromLevel(level: 3)
                        
                    }
                }
                
            }
        }

        func attemptShoot(player: String, shooter: SKSpriteNode, time: TimeInterval, spriteName: String) {
            if !mainMenuOpen {
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
    }

