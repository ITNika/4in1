//
//  GameScene.swift
//  Four-in-One
//
//  Created by Alexander (and Mikael) on 09/03/16.
//  Copyright (c) 2016 Alexander. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    /*  CONTACT   | player    |   button  |   Wall      |
    -----------------------------------------------------
    | player      |  yes      |   yes     | no          |
    -----------------------------------------------------
    | button      |  yes      |   -       | -           |
    -----------------------------------------------------
    | obstacles   |  no       |   -       | -           |
    -----------------------------------------------------*/
    
    /* COLLISION   | player    |   button  | Wall(on/off)|
        --------------------------------------------------
    | player       |  yes      |   yes     | yes/no      |
        --------------------------------------------------
    | button       |  no       |   -       | -           |
        --------------------------------------------------
    | obstacles    |  no       |   -       | -           |
    -----------------------------------------------------*/
    
    //Category mask values
    static let noCategory: UInt32 = 0x1 << 0
    static let playerCategory: UInt32  = 0x1 << 1
    static let buttonCategory: UInt32  = 0x1 << 2
    static let wallOnCategory: UInt32 = 0x1 << 3
    static let wallOffCategory: UInt32 = 0x1 << 4

    var players = [String : Player]()
    var obstacles = [String : Obstacle]()
    var buttons = [String: Button]()
    
    var gvc: GameViewController? //
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        // turn off gravity
        self.physicsWorld.gravity = CGVectorMake(0,0)
        // set self to contact delegate
        self.physicsWorld.contactDelegate = self
        //init scene
        self.initGameScene()
    }
    
    func initGameScene(){
        //init scenes in subclass
    }
    
    /*
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            debugPrint(touch)
        }
    }
    */
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            //get touch location and touched node
            let location = touch.locationInNode(scene!)
            let touchedNode = scene!.nodeAtPoint(location)
            
            //get name of touched node, if any
            if let name = touchedNode.name {
                //move a player?
                if let player = players[name] {
                    let newPosition = self.convertPointFromView(location)
                    player.position = newPosition
                    touchedNode.position = location //maybe add observer pattern between player and controller?
                }
            }
        }
    }
    
    func createShapeNodeFromModel(entity: AnyObject) -> SKShapeNode? {
        switch(entity){
        case let entity as Player:
            let playerRadius: CGFloat = 50
            let node = SKShapeNode(circleOfRadius: playerRadius)
            node.fillColor = entity.color
            //node.userInteractionEnabled = false
            node.physicsBody = SKPhysicsBody(circleOfRadius: playerRadius)
            node.position = self.convertPointToView(entity.position)
            node.physicsBody!.categoryBitMask = GameScene.playerCategory
            node.physicsBody!.contactTestBitMask = GameScene.playerCategory | GameScene.buttonCategory
            node.physicsBody!.collisionBitMask = GameScene.playerCategory | GameScene.wallOnCategory
            node.name = "\(entity.name)"
            return node
        case let entity as Obstacle:
            let size = CGSizeMake(entity.width, entity.height)
            let node = SKShapeNode(rectOfSize: size) //is later set the right size
            node.fillColor = entity.color
            node.userInteractionEnabled = false
            node.physicsBody = SKPhysicsBody(rectangleOfSize: size)
            node.position = self.convertPointToView(entity.position)
            debugPrint(node.position)
            node.physicsBody!.dynamic = false
            node.physicsBody!.categoryBitMask = GameScene.wallOnCategory
            node.physicsBody!.contactTestBitMask = GameScene.noCategory
            node.physicsBody!.collisionBitMask = GameScene.playerCategory
            node.name = "\(entity.name)"
            return node
        case let entity as Button:
            let size = CGSizeMake(100,100)
            let node = SKShapeNode(rectOfSize: size)
            node.fillColor = entity.color
            node.userInteractionEnabled = false
            node.physicsBody = SKPhysicsBody(rectangleOfSize: size)
            node.position = self.convertPointToView(entity.position)
            debugPrint(node.position)
            node.physicsBody!.dynamic = false
            node.physicsBody!.categoryBitMask = GameScene.buttonCategory
            node.physicsBody!.contactTestBitMask = GameScene.playerCategory
            node.physicsBody!.collisionBitMask = GameScene.noCategory
            node.name = "\(entity.name)"
            return node
        default: return nil
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        debugPrint("contact between \(contact.bodyA.node!.name) and \(contact.bodyB.node!.name) began")
        let A = contact.bodyA.node!
        let B = contact.bodyB.node!
        
        if let name = A.name { //get name of node A, if any
            debugPrint("A's name: \(name)")
            //is A a player?
            if let player = players[name] {
                solvePlayerContactBegan(player, otherNode: B)
            }
            
        }
        if let name = B.name { //get name of node B, if any
            //is B a player?
            if let player = players[name] {
                solvePlayerContactBegan(player, otherNode: A)
            }
        }
    }
    
    func solvePlayerContactBegan(player: Player, otherNode: SKNode){
        debugPrint("solving player contact began")
        
        //get name of other node, if any
        if let name = otherNode.name {
            //is other node a button
            if let button = buttons[name] {
                button.state = (player.color === button.color) ? .PRESSED_RIGHT_COLOR : .PRESSED_WRONG_COLOR
                
                if button.state == ButtonState.PRESSED_RIGHT_COLOR && isGameOver() {
                   gameOver()
                }
                
                for listener in button.listeners {
                    listener.onButtonStateChange(button.state)
                }
                debugPrint("solved contact between \(player.name) and \(button.name)")
            }
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        debugPrint("contact between \(contact.bodyA.node!.name) and \(contact.bodyB.node!.name) began")
        let A = contact.bodyA.node!
        let B = contact.bodyB.node!
        
        if let name = A.name { //get name of node A, if any
            debugPrint("A's name: \(name)")
            //is A a player?
            if let player = players[name] {
                
                solvePlayerContactEnded(player, otherNode: B)
            }
        }
        if let name = B.name { //get name of node B, if any
            //is B a player?
            if let player = players[name] {
                solvePlayerContactEnded(player, otherNode: A)
            }
        }
    }
    
    func solvePlayerContactEnded(player: Player, otherNode: SKNode){
        debugPrint("solving player contact ended")
        
        //get name of other node, if any
        if let name = otherNode.name {
            //is other node a button
            if let button = buttons[name] {
                button.state = .NOT_PRESSED
                for listener in button.listeners {
                    listener.onButtonStateChange(button.state)
                }
                debugPrint("solved contact between \(player.name) and \(button.name)")
            }
        }
    }
    
    func gameOver(){
        //override in subclasses
               debugPrint("game scene")
    }
    
    //resets level
    func reset() {
        scene!.removeAllChildren()
        players = [String : Player]()
        obstacles = [String : Obstacle]()
        buttons = [String: Button]()
        initGameScene()
    }
    
    //checks if win condition i met
    func isGameOver() -> Bool{
        for b in buttons {
            let button = b.1
            if(button.state != ButtonState.PRESSED_RIGHT_COLOR){
                return false
            }
        }
        return true
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        /* makes collision between players lag
        for p in players {
            let player = p.1
            let name = player.name
            let node = scene!.childNodeWithName(name)!
            node.position = self.convertPointToView(player.position)
        } */
        
        for o in obstacles {
            let obstacle = o.1
            let name = obstacle.name
            let node = scene!.childNodeWithName(name)!
            if(obstacle.isActive){
                node.physicsBody!.categoryBitMask = GameScene.wallOnCategory
                node.alpha = 1
            } else {
                node.physicsBody!.categoryBitMask = GameScene.wallOffCategory
                node.alpha = 0.15
            }
        }
    }
}
