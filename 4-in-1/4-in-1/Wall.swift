//
//  Wall.swift
//  Four-in-One
//
//  Created by Andreas Henriksson on 2016-03-17.
//  Copyright © 2016 Alexander. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Wall: Entity {
    static private var counter: Int = 0
    static let entityName = "wall"
    let id: Int
    let name: String
    var node: SKShapeNode = SKShapeNode()
    var position: CGPoint
    var width, height: CGFloat
    
    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat){
        self.width = width
        self.height = height
        self.position = CGPointMake(x, y)
        self.id = Wall.newId()
        self.name = "\(Wall.entityName) \(self.id)"
        
        //init node
        let size = CGSizeMake(self.width, self.height)
        let node = SKShapeNode(rectOfSize: size)
        node.fillColor = UIColor.whiteColor()
        node.userInteractionEnabled = false
        node.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        node.physicsBody!.dynamic = false
        node.physicsBody!.categoryBitMask = CategoryMask.wallOnCategory
        node.physicsBody!.contactTestBitMask = CategoryMask.noCategory
        node.physicsBody!.collisionBitMask = CategoryMask.playerCategory
        node.name = "\(self.name)"

    }
    static func newId() -> Int {
        let newId = Wall.counter
        Wall.counter += 1
        return newId
    }
}
