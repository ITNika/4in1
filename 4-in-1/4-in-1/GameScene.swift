//
//  GameScene.swift
//  4-in-1
//
//  Created by Alexander on 17/03/16.
//  Copyright (c) 2016 Chalmers. All rights reserved.
//

import SpriteKit
import MultipeerConnectivity

class GameScene: SKScene, Scene, SKPhysicsContactDelegate, ConnectionListener, GameEventListener {
    //entities
    var characters = [Character]()
    var movingCharacter: Character?
    var obstacles = [Obstacle]()
    var buttons = [Button]()
    var portals = [Portal]()
    
    //other
    var cm : ConnectivityManager?
    var gvc : GameViewController?
    var ipadNr : Int = 0
    //animations
    let fadeIn : SKAction  = SKAction.fadeInWithDuration(1)
    let fadeOut : SKAction  = SKAction.fadeOutWithDuration(1)
    let scaleUp : SKAction = SKAction.scaleBy(CGFloat(1.2), duration: 0.2)
    let scaleDown : SKAction = SKAction.scaleBy(1/1.2, duration: 0.2)
    
    override func didMoveToView(view: SKView) {
        debugPrint("did move to game scene view")
        //add timing functions to scale animations
        fadeIn.timingFunction = {sin($0*Float(M_PI_2))}
        fadeOut.timingFunction = { sin($0*Float(M_PI_2))}
        scaleUp.timingFunction = {sin($0*Float(M_PI_2))}
        scaleDown.timingFunction = {sin($0*Float(M_PI_2))}
        //stop advertising
        //cm?.stopHosting()
        //remove gravity
        self.physicsWorld.gravity = CGVectorMake(0,0)
        // set self to contact delegate
        self.physicsWorld.contactDelegate = self
        //init scene
        self.initGameScene()
    }
    
    func initGameScene(){
        //switch on ipadNr
        debugPrint("ipadNr: \(ipadNr)")
        if ipadNr % 2 == 0 {
            self.view?.scene?.backgroundColor = ColorManager.colors[ColorString.salmon]!
        } else {
            self.view?.scene?.backgroundColor = ColorManager.colors[ColorString.yellow]!
        }

        scene!.scaleMode = .AspectFill
        /********************************
         WALLS
         ********************************/
        let screenWidth: CGFloat = scene!.size.width
        let screenHeight: CGFloat = scene!.size.height
        var walls = [Wall]()
        walls.append(Wall(x: 0, y: screenHeight/2 , width: 1, height: screenHeight))
        walls.append(Wall(x: screenWidth/2, y: 0 , width: screenWidth, height: 1))
        walls.append(Wall(x: screenWidth, y: screenHeight/2 , width: 1, height: screenHeight))
        walls.append(Wall(x: screenWidth/2, y: screenHeight , width: screenWidth, height: 1))

        /********************************
         OBSTACLES
         ********************************/
        let obstacle = Obstacle(x: screenWidth/2, y: screenHeight/2 , color: ColorManager.colors[ColorString.blue]!, width: 75, height: screenHeight)
        obstacles.append(obstacle)
        
  
        /********************************
         BUTTONS
         ********************************/
        
        // create blue and red button
        let blueButton = Button(x: 300, y: 100, color: ColorManager.colors[ColorString.blue]!)
        let redButton = Button(x: 800, y: 600, color: ColorManager.colors[ColorString.red]!)

        //add blue and red button to buttons
        buttons.append(blueButton)
        buttons.append(redButton)
        
        //add blue wall as button listener
        blueButton.listeners.append(obstacle)
        

        /********************************
         PORTALS
         ********************************/
        let bluePortal = Portal(x: 250, y: 250, color: ColorManager.colors[ColorString.blue]!)
        portals.append(bluePortal)
        
        /********************************
         PLAYERS
         ********************************/
        
        // create players
        let bluePlayer = Character(x: 100, y: 100, color: ColorManager.colors[ColorString.blue]!)
        let redPlayer = Character(x: 400, y: 700, color: ColorManager.colors[ColorString.red]!)
        
        // add to players....
        characters.append(bluePlayer)
        characters.append(redPlayer)
        
        /************
        ADD ALL NODES
        *************/
        
        for wall in walls {
            wall.node.position = self.convertPointToView(wall.position)
            self.scene!.addChild(wall.node)
        }
        for o in obstacles {
            o.node.position = self.convertPointToView(o.position)
            self.scene!.addChild(o.node)
        }
        for b in buttons {
            b.node.position = self.convertPointToView(b.position)
            self.scene!.addChild(b.node)
        }
        for c in characters {
            c.node.position = self.convertPointToView(c.position)
            self.scene!.addChild(c.node)
        }
        for p in portals {
            p.node.position = self.convertPointToView(p.position)
            self.scene!.addChild(p.node)
        }
        
    }
 
    func didBeginContact(contact: SKPhysicsContact) {
        debugPrint("contact between \(contact.bodyA.node!.name) and \(contact.bodyB.node!.name) began")
        let A = contact.bodyA.node!
        let B = contact.bodyB.node!
        
        if let name = A.name { //get name of node A, if any
            debugPrint("A's name: \(name)")
            //is A a player?
            if let character = getCharacterByName(name) {
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
                if let colorStr : ColorString = ColorManager.getColorString(character.color)! {
                    cm?.fireGameEvent(.sendCharacter(characterColor: colorStr, portalName: "A"), onlyBroadcast: true)
                    characterNode.runAction(fadeOut, completion: {
                        self.removeCharacter(character)
                        characterNode.removeFromParent()
                    })
                } else {
                    debugPrint("did not find color")
                }
                //gvc?.cm?.sendString("player \(colorStr)")
            }
        }
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

            
            let touchedNode = scene!.nodeAtPoint(location)
            
            //get name of touched node, if any
            if let name = touchedNode.name {
                debugPrint(name )
                //move a player?
                if let character = getCharacterByName(name) {
                    movingCharacter = character
                    touchedNode.runAction(scaleUp) //
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

                //touched a obstacle?
                if let _ = getObstacleByName(name) {
                    movingCharacter = nil
                    debugPrint("OPS")
                }
            }

            if movingCharacter != nil {
                let newPosition = self.convertPointFromView(location)
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
        if movingCharacter != nil  {
            if let node = self.childNodeWithName(movingCharacter!.name){
                node.runAction(scaleDown)
            }
            movingCharacter = nil
        }

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
    
    func spawnCharacter(color: UIColor){
        // create character
        let newCharacter = Character(x: 300, y: 600, color: color)
        
        // create node
        //let node = createShapeNodeFromModel(newCharacter)!
        newCharacter.node.alpha = 0
        newCharacter.node.position = self.convertPointToView(newCharacter.position)
        // add to characters....
        characters.append(newCharacter)
        // add node to scene
        scene!.addChild(newCharacter.node)
        newCharacter.node.runAction(fadeIn)
    }
    
    // Game Event Listener
    func onEvent(event: GameEvent) {
        switch event {
        case let .sendCharacter(characterColor, _):
            spawnCharacter(ColorManager.colors[characterColor]!)
            break
        //handle more events later
        default:
            break
        }
    }
    
    func onConnectionStateChange(state : MCSessionState){
        switch(state) {
        case .NotConnected:
            self.view?.scene?.backgroundColor = UIColor.redColor()
            gvc?.goToMenuScene()
            break
        case .Connecting: self.view?.scene?.backgroundColor = UIColor.blueColor()
            break
        case .Connected: self.view?.scene?.backgroundColor = UIColor.greenColor()
            break
        }
    }
}