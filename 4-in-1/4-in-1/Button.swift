//
//  Button .swift
//  Four-in-One
//
//  Created by Alexander on 10/03/16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Button: ColoredEntity {
    static private var counter: Int = 0
    static let entityName = "button"
    let id: Int
    let name: String
    var node: SKShapeNode
    var position: CGPoint
    let color: UIColor
    //added a property to count the number of players on a button
    var visitors: Int
    
    var state: ButtonState = .NOT_PRESSED {
        didSet {
            for listener in listeners {
                listener.onButtonStateChange(self)
            }
        }
    }
    
    var listeners: [ButtonListener] = []
    
    init(x: CGFloat, y: CGFloat, color: UIColor) {
        self.id = Button.newId()
        self.color = color
        self.name = "\(Button.entityName) \(self.id)"
        self.position = CGPointMake(x,y)
        self.visitors = 0
        
        //init node
        let size = CGSizeMake(100,100)
        node = SKShapeNode(rectOfSize: size)
        node.fillColor = self.color
        node.userInteractionEnabled = false
        node.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        node.physicsBody!.dynamic = false
        node.physicsBody!.categoryBitMask = CategoryMask.buttonCategory
        node.physicsBody!.contactTestBitMask = CategoryMask.playerCategory
        node.physicsBody!.collisionBitMask = CategoryMask.noCategory
        node.name = "\(self.name)"
    }
    
    func unpress(){
        self.state = .NOT_PRESSED
    }
    
    func press(character: Character){
        self.state = (character.color === self.color) ? .PRESSED_RIGHT_COLOR : .PRESSED_WRONG_COLOR
    }
    
    static func newId()-> Int {
        let newId = Button.counter
        Button.counter += 1
        return newId
    }
    
}