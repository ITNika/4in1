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
    
    init(x: CGFloat, y: CGFloat, color: UIColor, name: String, destination: String) {
        self.position = CGPointMake(x, y)
        self.color = color
        self.id = Portal.newId()
        self.name = name
        self.destination = destination
        
        //init node
        node = SKShapeNode()
        node.path = UIBezierPath(roundedRect: CGRect(x: -50, y: -50, width: 100, height: 100), cornerRadius: 25).CGPath
        let size = CGSizeMake(100,100)
        node.fillColor = self.color
        node.alpha = 1
        node.userInteractionEnabled = false
        node.physicsBody = SKPhysicsBody(rectangleOfSize: size)
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