import SpriteKit
import GameplayKit

class Shoot: SKSpriteNode {
    var owner: String = ""

    func shootBullet(from ship: SKSpriteNode, in scene: SKScene, at location: CGPoint, pOwner: String, pSprite: String) -> Shoot {
        let bullet = Shoot(imageNamed: pSprite)
        bullet.zPosition = -5
        bullet.owner = pOwner

        bullet.position = ship.position
        bullet.zRotation = ship.zRotation
        bullet.zPosition = ship.zPosition

        let velocity: CGFloat = 1000.0
        let dx = cos(ship.zRotation) * velocity
        let dy = sin(ship.zRotation) * velocity
        let moveAction = SKAction.move(by: CGVector(dx: dx, dy: dy), duration: 1.0)
        let actionDone = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([moveAction, actionDone]))

        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.isDynamic = false

        scene.addChild(bullet)
        return bullet
    }
}
