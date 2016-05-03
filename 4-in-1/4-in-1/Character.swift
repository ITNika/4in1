//
//  Character.swift
//  4-in-1
//
//  Created by Alexander on 17/03/16.
//  Copyright © 2016 Chalmers. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Character: ColoredEntity {
    static private var counter: Int = 0
    static let entityName = "character"
    var node: SKShapeNode
    let id: Int
    let name: String
    var position: CGPoint {
        didSet {
            debugPrint("didSet")
            if node.scene != nil {
                node.position = (node.scene?.convertPointToView(self.position))!
            }
        }
    }
    let color: UIColor
    
    init(x: CGFloat, y: CGFloat, color : UIColor) {

        self.position = CGPointMake(x,y)
        self.id  = Character.newId()
        self.color = color
        self.name = "\(Character.entityName) \(self.id)"
        
        //todo init node
        let playerRadius: CGFloat = 50
        node = SKShapeNode(circleOfRadius: playerRadius)
        node.fillColor = self.color
        node.physicsBody = SKPhysicsBody(circleOfRadius: playerRadius)
        node.physicsBody!.categoryBitMask = CategoryMask.playerCategory
        node.physicsBody!.contactTestBitMask = CategoryMask.playerCategory | CategoryMask.buttonCategory
        node.physicsBody!.collisionBitMask = CategoryMask.playerCategory | CategoryMask.wallOnCategory
        node.name = "\(self.name)"
        //node.scene?.convertPointToView(self.position)
    }
    
    static func newId() -> Int {
        let newId = Character.counter
        Character.counter += 1
        return newId
    }
}
