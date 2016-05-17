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
    
    let rotation = SKAction.rotateByAngle(CGFloat(M_PI_4), duration: 0.5)
    let rotWrong = SKAction.rotateToAngle(0, duration: 0.3, shortestUnitArc: true)
    let rotRight = SKAction.rotateToAngle( CGFloat(M_PI_4), duration: 0.3, shortestUnitArc: true)
    
    
    var state: ButtonState = .NOT_PRESSED {
        didSet {
            node.runAction(state == .PRESSED_RIGHT_COLOR ? rotRight : rotWrong, completion: {
                for listener in self.listeners {
                    listener.onButtonStateChange(self)
                }
            })
            //node.strokeColor = getStrokeColor()
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
        node.fillColor = UIColor.clearColor()
        node.lineWidth = 10
        //node.strokeTexture?.filteringMode = SKTextureFilteringMode.Nearest
        node.strokeColor = self.color
        node.antialiased = false
        node.userInteractionEnabled = false
        node.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        node.physicsBody!.dynamic = false
        node.physicsBody!.categoryBitMask = CategoryMask.buttonCategory
        node.physicsBody!.contactTestBitMask = CategoryMask.playerCategory
        node.physicsBody!.collisionBitMask = CategoryMask.noCategory
        node.name = "\(self.name)"
    }
    
    func getStrokeColor()->UIColor {
        return state == .PRESSED_RIGHT_COLOR ? ColorManager.colors[ColorString.tealDark]! : UIColor.clearColor()
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