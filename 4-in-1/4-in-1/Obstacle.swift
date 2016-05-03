//
//  Obstacle.swift
//  Four-in-One
//
//  Created by Alexander on 09/03/16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Obstacle: ColoredEntity  {
    static private var counter: Int = 0
    static let entityName = "obstacle"
    let id: Int
    let name: String
    var position: CGPoint
        var node: SKShapeNode = SKShapeNode()
    let color: UIColor
    var width, height: CGFloat
    
    var isActive: Bool = true {
        didSet {
            debugPrint(" \(self.name) is active: \(isActive) )")
            if isActive {
                node.physicsBody!.categoryBitMask = CategoryMask.wallOnCategory
                node.alpha = 1
            } else {
                node.physicsBody!.categoryBitMask = CategoryMask.wallOffCategory
                node.alpha = 0.15
            }
        }
    }
    
    init(x: CGFloat, y: CGFloat, color: UIColor, width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
        self.position = CGPointMake(x, y)
        self.color = color
        self.id = Obstacle.newId()
        self.name = "\(Obstacle.entityName) \(self.id)"
        
        //init node
        let size = CGSizeMake(self.width, self.height)
        node = SKShapeNode(rectOfSize: size) //is later set the right size
        node.fillColor = self.color
        node.userInteractionEnabled = false
        node.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        node.physicsBody!.dynamic = false
        node.physicsBody!.categoryBitMask = CategoryMask.wallOnCategory
        node.physicsBody!.contactTestBitMask = CategoryMask.noCategory
        node.physicsBody!.collisionBitMask = CategoryMask.playerCategory
        node.name = "\(self.name)"
    }
        
    static func newId() -> Int {
        let newId = Obstacle.counter
        Obstacle.counter += 1
        return newId
    }
}