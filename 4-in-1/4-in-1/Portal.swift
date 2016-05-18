//
//  Portal.swift
//  4-in-1
//
//  Created by Alexander on 28/04/16.
//  Copyright © 2016 Chalmers. All rights reserved.
//

import Foundation
import SpriteKit

class Portal: ColoredEntity {
    static private var counter: Int = 0
    static let entityName = "portal"
    let id: Int
    let name: String
    var node: SKShapeNode = SKShapeNode()
    var position: CGPoint
    let color: UIColor
    var isActive : Bool = true
    let destination: String
    
    init(x: CGFloat, y: CGFloat, color: UIColor, name: String, destination: String, rotation : Rotation) {
        self.position = CGPointMake(x, y)
        self.color = color
        self.id = Portal.newId()
        self.name = name
        self.destination = destination
        

        
        //init node
        node = SKShapeNode()
        
        let size = CGSizeMake(50,50)
        let trianglePath = CGPathCreateMutable()
        CGPathMoveToPoint(trianglePath, nil, -size.width, -size.height)
        CGPathAddLineToPoint(trianglePath, nil, size.width, -size.height)
        CGPathAddLineToPoint(trianglePath, nil, 0, size.height)
        CGPathAddLineToPoint(trianglePath, nil, -size.width, -size.height)
        
        node.path = trianglePath
        
        node.fillColor = self.color
        node.alpha = 1
        node.userInteractionEnabled = false
        
        node.physicsBody = SKPhysicsBody(polygonFromPath: trianglePath)
        
        node.runAction(SKAction.rotateToAngle(Rotation.getRad(rotation), duration: 0))
        //node.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        node.physicsBody!.dynamic = false
        node.physicsBody!.categoryBitMask = CategoryMask.portalCategory
        node.physicsBody!.contactTestBitMask = CategoryMask.playerCategory
        node.physicsBody!.collisionBitMask = CategoryMask.noCategory
        node.name = "\(self.name)"
    }
    
    static func newId() -> Int {
        let newId =  Portal.counter
        Portal.counter += 1
        return newId
    }

}