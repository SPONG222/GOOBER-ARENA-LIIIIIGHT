//
//  Collisions.swift
//  GOOBER ARENA LIIIIIGHT
//
//  Created by Zachary M. Sheldon on 5/8/25.
//

import SpriteKit
import GameplayKit
import Foundation

func PointBoxCollision(point: CGPoint, boxPos: CGPoint, boxSize: CGSize) -> Bool {
    if (point.x >= boxPos.x && point.x <= boxPos.x + boxSize.width && point.y >= boxPos.y && point.y <= boxPos.y + boxSize.height) {
        return true
    }
    
    return false
}

func BoxCollision(aPos: CGPoint, aSize: CGSize, bPos: CGPoint, bSize: CGSize) -> Bool {
    if(
        aPos.x <= bPos.x + bSize.width &&
        aPos.x + aSize.width >= bPos.x &&
        aPos.y <= bPos.y + bSize.height &&
        aPos.y + aSize.height >= bPos.y
    ) {
        return true
    }
    
    return false
}
