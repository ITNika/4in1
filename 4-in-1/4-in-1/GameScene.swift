//
//  GameScene.swift
//  4-in-1
//
//  Created by Alexander on 17/03/16.
//  Copyright (c) 2016 Chalmers. All rights reserved.
//

import SpriteKit
import MultipeerConnectivity

class GameScene: SKScene, Scene, SKPhysicsContactDelegate, ConnectionListener {
    /*  CONTACT   | player    |   button  |   Wall      |      /* COLLISION   | player    |   button  | Wall(on/off)|
    -----------------------------------------------------       --------------------------------------------------
    | player      |  yes      |   yes     | no          |      | player       |  yes      |   yes     | yes/no      |
    -----------------------------------------------------       --------------------------------------------------
    | button      |  yes      |   -       | -           |      | button       |  no       |   -       | -           |
    -----------------------------------------------------      --------------------------------------------------
    | obstacles   |  no       |   -       | -           |      | obstacles    |  no       |   -       | -           |
     ----------------------------------------------------*/    -----------------------------------------------------*/
    
    //Category mask values
    static let noCategory: UInt32 = 0x1 << 0
    static let playerCategory: UInt32  = 0x1 << 1
    static let buttonCategory: UInt32  = 0x1 << 2
    static let wallOnCategory: UInt32 = 0x1 << 3
    static let wallOffCategory: UInt32 = 0x1 << 4
    static let portalCategory: UInt32 = 0x1 << 5 // todo ^- add portal to tables
    
    //entities
    var characters = [Character]()
    var movingCharacter: Character?
    var obstacles = [Obstacle]()
    var buttons = [Button]()
    var portals = [Portal]()
    
    //colors
    let colorMap: [String : UIColor]  = [ "blue" : UIColor.blueColor(),
                                          "red" : UIColor.redColor() ]

    //other
    var cm : ConnectivityManager?
    var gvc : GameViewController?
    var ipadNr : Int = 0
    
    override func didMoveToView(view: SKView) {
        debugPrint("did move to game scene view")
        
        //stop advertising
        cm?.stopHosting()
        //remove gravity
        self.physicsWorld.gravity = CGVectorMake(0,0)
        // set self to contact delegate
        self.physicsWorld.contactDelegate = self
        //init scene
        self.initGameScene()
    }
    
    func initGameScene(){
        //switch on ipadNr
        switch ipadNr {
        case 1:
            break
        case 2:
            break
        default:
            break
        }
        
        /********************************
        WALLS
        ********************************/
        // create wall model
        scene!.scaleMode = .AspectFill
        let screenWidth: CGFloat = scene!.size.width
        let screenHeight: CGFloat = scene!.size.height
        let borderWalls = [
            Wall(x: 0, y: screenHeight/2 , width: 1, height: screenHeight),
            Wall(x: screenWidth/2, y: 0 , width: screenWidth, height: 1),
            Wall(x: screenWidth, y: screenHeight/2 , width: 1, height: screenHeight),
            Wall(x: screenWidth/2, y: screenHeight , width: screenWidth, height: 1)
        ]
        for borderWall in borderWalls{
            // create wall node
            let wallNode = createShapeNodeFromModel(borderWall)!
            // add wall to scene
            scene!.addChild(wallNode)
        }
        /********************************
         OBSTACLES
         ********************************/
        let wall = Obstacle(x: screenWidth/2, y: screenHeight/2 , color: colorMap["blue"]!, width: 75, height: screenHeight)
        
        // create wall node
        let wallNode = createShapeNodeFromModel(wall)!
        
        // add wall to scene
        scene!.addChild(wallNode)
        
        //add to abstacles
        obstacles.append(wall)
        
        /********************************
         BUTTONS
         ********************************/
         
         // create blue and red button
        let blueButton = Button(x: 300, y: 100, color: colorMap["blue"]!)
        let redButton = Button(x: 800, y: 600, color: colorMap["red"]!)
        
        //create blue and red button node
        let blueButtonNode = createShapeNodeFromModel(blueButton)!
        let redButtonNode = createShapeNodeFromModel(redButton)!
        
        //add blue and red button to scene
        scene!.addChild(blueButtonNode)
        scene!.addChild(redButtonNode)
        
        //add blue and red button to buttons
        buttons.append(blueButton)
        buttons.append(redButton)
        
        //add blue wall as button listener
        blueButton.listeners.append(wall)
        
        /********************************
         PORTALS
         ********************************/
        let bluePortal = Portal(x: 250, y: 250, color: colorMap["blue"]!)
        let portalNode = createShapeNodeFromModel(bluePortal)!
        scene!.addChild(portalNode)
        portals.append(bluePortal)
        
        
        /********************************
         PLAYERS
         ********************************/
         
         // create players
        let bluePlayer = Character(x: 100, y: 100, color: colorMap["blue"]!)
        let redPlayer = Character(x: 400, y: 700, color: colorMap["red"]!)
        
        // create player Nodes
        let bluePlayerNode = createShapeNodeFromModel(bluePlayer)!
        let redPlayerNode = createShapeNodeFromModel(redPlayer)!
        
        // add player node to scene
        scene!.addChild(bluePlayerNode)
        scene!.addChild(redPlayerNode)
        
        // add to players....
        characters.append(bluePlayer)
        characters.append(redPlayer)
    
    }
    
    func createShapeNodeFromModel(entity: AnyObject) -> SKShapeNode? {
        switch(entity){
        case let entity as Character:
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
        case let entity as Wall:
            let size = CGSizeMake(entity.width, entity.height)
            let node = SKShapeNode(rectOfSize: size)
            node.fillColor = UIColor.whiteColor()
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
        case let entity as Portal:
            let node = SKShapeNode()
            node.path = UIBezierPath(roundedRect: CGRect(x: -50, y: -50, width: 100, height: 100), cornerRadius: 25).CGPath
            let size = CGSizeMake(100,100)
            node.fillColor = entity.color
            node.alpha = 0.3
            node.userInteractionEnabled = false
            node.physicsBody = SKPhysicsBody(rectangleOfSize: size)
            node.position = self.convertPointToView(entity.position)
            debugPrint(node.position)
            node.physicsBody!.dynamic = false
            node.physicsBody!.categoryBitMask = GameScene.portalCategory
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
            if let character = getCharacterByName(name)  {
                solvePlayerContactBegan(character, characterNode: A, otherNode: B)
            }
            
        }
        if let name = B.name { //get name of node B, if any
            //is B a player?
            if let character = getCharacterByName(name) {
                solvePlayerContactBegan(character, characterNode: B, otherNode: A)
            }
        }
    }
    
    func solvePlayerContactBegan(character: Character, characterNode: SKNode, otherNode: SKNode){
        debugPrint("solving player contact began")
        
        //get name of other node, if any
        if let name = otherNode.name {
            //is other node a button
            if let button = getButtonByName(name) {
                if button.state != .PRESSED_RIGHT_COLOR{
                    button.state = (character.color === button.color) ? .PRESSED_RIGHT_COLOR : .PRESSED_WRONG_COLOR
                }
                button.visitors = button.visitors + 1
                if button.state == ButtonState.PRESSED_RIGHT_COLOR && isGameOver() {
                    gameOver()
                }
                if button.visitors == 1{
                    for listener in button.listeners {
                        listener.onButtonStateChange(button.state)
                    }
                }
                debugPrint("solved contact between \(character.name) and \(button.name)")
            } else if getPortalByName(name) != nil {
                debugPrint("touching portal")
                let colorStr : String = getColorString(character.color)!;
                gvc?.cm?.sendString("player \(colorStr)")
                removeCharacter(character)
                characterNode.removeFromParent()
            }
        }
    }
    
    func getColorString(color: UIColor) -> String?{
        for key in colorMap.keys {
            if(colorMap[key] == color){
                return key
            }
        }
        return nil
    }
    
    
    func removeCharacter(character: Character){
        var index = 0
        for c in characters {
            if(c.name == character.name){
                characters.removeAtIndex(index)
            }
            index += 1
        }
    }
    
    
    func didEndContact(contact: SKPhysicsContact) {
        debugPrint("contact between \(contact.bodyA.node!.name) and \(contact.bodyB.node!.name) ended")
        let A = contact.bodyA.node!
        let B = contact.bodyB.node!
        
        if let name = A.name { //get name of node A, if any
            debugPrint("A's name: \(name)")
            //is A a player?
            if let character = getCharacterByName(name) {
                solvePlayerContactEnded(character, otherNode: B)
            }
        }
        if let name = B.name { //get name of node B, if any
            //is B a player?
            if let character = getCharacterByName(name) {
                solvePlayerContactEnded(character, otherNode: A)
            }
        }
    }
    
    func solvePlayerContactEnded(character: Character, otherNode: SKNode){
        debugPrint("solving player contact ended")
        
        //get name of other node, if any
        if let name = otherNode.name {
            //is other node a button
            if let button = getButtonByName(name) {
                button.visitors = button.visitors - 1
                if button.visitors == 0{
                    button.state = .NOT_PRESSED
                    for listener in button.listeners {
                        listener.onButtonStateChange(button.state)
                    }
                }
                    //Assuming that there is only one player of each color
                else if character.color == button.color{
                    button.state = .PRESSED_WRONG_COLOR
                }
                debugPrint("solved contact between \(character.name) and \(button.name)")
            }
        }
    }
    
    func gameOver(){
        //override in subclasses
        gvc?.goToMenuScene()
    }
    
    //resets level
    func reset() {
        scene!.removeAllChildren()
        characters = [Character]()
        movingCharacter = nil
        obstacles = [Obstacle]()
        buttons = [Button]()
        initGameScene()
    }
    
    //checks if win condition i met
    func isGameOver() -> Bool{
        for button in buttons {
            if(button.state != ButtonState.PRESSED_RIGHT_COLOR){
                return false
            }
        }
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        movingCharacter = nil
        
        //if touch began on player -> player = movingPlayer
        for touch in touches {
            //get touch location and touched node
            let location = touch.locationInNode(self)
            debugPrint("touch @   \(self.convertPointToView(location)) ")
            let touchedNode = scene!.nodeAtPoint(location)
            
            //get name of touched node, if any
            if let name = touchedNode.name {
                debugPrint(name )
                //move a player?
                if let character = getCharacterByName(name) {
                    movingCharacter = character
                    debugPrint("\(name) is moving")
                } else {
                    debugPrint("No character with that name....")
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            //get touch location and touched node
            let location = touch.locationInNode(scene!)
            let touchedNode = scene!.nodeAtPoint(location)
            
            if let name = touchedNode.name {
                debugPrint(name )
                //touched a obstacle?
                if let _ = getObstacleByName(name) {
                    movingCharacter = nil
                    debugPrint("OPS")
                }
            }

            if movingCharacter != nil {
                let newPosition = self.convertPointFromView(location)
                debugPrint("\(newPosition)")
                let oldPosition = movingCharacter!.position
                let deltaX = newPosition.x - oldPosition.x
                let deltaY = newPosition.y - oldPosition.y
                let distance = hypot(deltaX, deltaY);
                
                let maxDistance: CGFloat = 75
                if(distance <= maxDistance){
                    movingCharacter!.position = newPosition
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        debugPrint("\(movingCharacter?.name) stopped moving")
        movingCharacter = nil
    }
    
    
    private func getCharacterByName(name: String) -> Character? {
        for c in characters {
            if(c.name == name){
                return c
            }
        }
        return nil
    }
    
    private func getButtonByName(name: String) -> Button? {
        for b in buttons {
            if(b.name == name){
                return b
            }
        }
        return nil
    }
    
    private func getObstacleByName(name: String) -> Obstacle? {
        for o in obstacles {
            if(o.name == name){
                return o
            }
        }
        return nil
    }
    
    private func getPortalByName(name: String) -> Portal? {
        for p in portals {
            if(p.name == name){
                return p
            }
        }
        return nil
    }
    
    private func getEntityByName(name: String, entities: [Entity]) -> Entity? {
        for e in entities {
            if(e.name == name){
                return e
            }
        }
        return nil
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        //update character nodes
        for c in characters {
            if let node = self.childNodeWithName(c.name) {
                node.position = self.convertPointToView(c.position)
            }
        }
        
        for obstacle in obstacles {
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
    
    func spawnCharacter(color: UIColor){
        // create character
        let newCharacter = Character(x: 300, y: 600, color: color)
        
        // create node
        let node = createShapeNodeFromModel(newCharacter)!
        
        // add node to scene
        scene!.addChild(node)
        
        // add to characters....
        characters.append(newCharacter)
    }

    //Connection Listener
    func handleMessage(message: String){
        //self.view?.scene?.backgroundColor = UIColor.brownColor()
        let arr = message.componentsSeparatedByString(" ")
        if(arr[0] == "player"){
            let color = colorMap[arr[1]]
            if color != nil {
                spawnCharacter(color!)
            }
        }
    }
    
    func onConnectionStateChange(state : MCSessionState){
        switch(state) {
        case .NotConnected: self.view?.scene?.backgroundColor = UIColor.redColor()
            gvc?.goToMenuScene()
            break
        case .Connecting: self.view?.scene?.backgroundColor = UIColor.blueColor()
            break
        case .Connected: self.view?.scene?.backgroundColor = UIColor.greenColor()
            break
        }
    }
}