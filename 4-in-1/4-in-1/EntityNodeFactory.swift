//
//  EntityNodeFactory.swift
//  4-in-1
//
//  Created by Alexander on 17/03/16.
//  Copyright © 2016 Chalmers. All rights reserved.
//

import Foundation
import SpriteKit

class EntityNodeFactory {
    let characterRadius: CGFloat = 50
    
    
    func createShapeNodeFromModel(entity: AnyObject, scene: GameScene) -> SKShapeNode? {
        switch(entity){
        case let entity as Character:
            let node = SKShapeNode(circleOfRadius: characterRadius)
            node.fillColor = entity.color
            //node.userInteractionEnabled = false
            node.physicsBody = SKPhysicsBody(circleOfRadius: characterRadius)
            node.position = scene.convertPointToView(entity.position)
            //node.physicsBody!.categoryBitMask = GameScene.playerCategory
            //node.physicsBody!.contactTestBitMask = GameScene.playerCategory | GameScene.buttonCategory
            //node.physicsBody!.collisionBitMask = GameScene.playerCategory | GameScene.wallOnCategory
            node.name = "\(entity.name)"
            return node
        default:
                return nil
        }
    }
}