//
//  GameScene.swift
//  4-in-1
//
//  Created by Alexander on 17/03/16.
//  Copyright (c) 2016 Chalmers. All rights reserved.
//

import SpriteKit
import MultipeerConnectivity

class GameScene: SKScene, Scene, SKPhysicsContactDelegate, ConnectionListener, InGameEventListener, NetworkGameEventListener, ButtonListener {
    //entities
    var walls = [Wall]()
    var characters = [Character]()
    var obstacles = [Obstacle]()
    var buttons = [Button]()
    var portals = [Portal]()
    var movingCharacter: Character?
    var winConditions = [Bool]() {
        didSet {
            debugPrint(winConditions)
            var endGame = true
            for index in 0...winConditions.count - 1 {
                let value = winConditions[index]
                debugPrint("ipadNr \(index) is \(value),  winConditions length = \(winConditions.count)")
                if !value {
                    endGame = false
                    break
                }
            }
            if endGame {
                fireGameEvent(GameEvent.gameOver)
            }
        }
    }
    
    //other
    var cm : ConnectivityManager?
    var gvc : GameViewController?
    var ipadNr : Int = 0
    
    var numberOfPlayers : Int = 1 {
        didSet {
            debugPrint("**********************************")
            debugPrint("new value for numbers of players \(numberOfPlayers)")
            winConditions = [Bool](count: numberOfPlayers, repeatedValue: false)
            debugPrint(winConditions)
            debugPrint("winConditions has count \(winConditions.count)")
                        debugPrint("**********************************")
        }
    }
    
    var gameEventListeners = [InGameEventListener]()
    
    //animations
    let fadeIn : SKAction  = SKAction.fadeInWithDuration(1)
    let fadeOut : SKAction  = SKAction.fadeOutWithDuration(1)
    let scaleUp : SKAction = SKAction.scaleBy(CGFloat(1.2), duration: 0.2)
    let scaleDown : SKAction = SKAction.scaleBy(1/1.2, duration: 0.2)
    
    override func didMoveToView(view: SKView) {
        //add timing functions to scale animations
        fadeIn.timingFunction = {sin($0*Float(M_PI_2))}
        fadeOut.timingFunction = { sin($0*Float(M_PI_2))}
        scaleUp.timingFunction = {sin($0*Float(M_PI_2))}
        scaleDown.timingFunction = {sin($0*Float(M_PI_2))}
        //stop advertising
        cm?.stopHosting()
        //remove gravity
        self.physicsWorld.gravity = CGVectorMake(0,0)
        // set self to contact delegate
        self.physicsWorld.contactDelegate = self
        //init scene
        scene!.scaleMode = .AspectFill
        self.reset() // removes all entities and their nodes
        //walls
        setUpWalls()
        self.initGameScene()
    }
    
    func setUpWalls(){
        /********************************
         WALLS
         ********************************/
        let screenWidth: CGFloat = scene!.size.width
        let screenHeight: CGFloat = scene!.size.height
        walls.append(Wall(x: 0, y: screenHeight/2 , width: 1, height: screenHeight))
        walls.append(Wall(x: screenWidth/2, y: 0 , width: screenWidth, height: 1))
        walls.append(Wall(x: screenWidth, y: screenHeight/2 , width: 1, height: screenHeight))
        walls.append(Wall(x: screenWidth/2, y: screenHeight , width: screenWidth, height: 1))
        
        for wall in walls {
            wall.node.position = self.convertPointToView(wall.position)
            self.scene!.addChild(wall.node)
        }
    }
    
    func initGameScene(){
        //switch on ipadNr
        debugPrint("ipadNr: \(ipadNr)")
        /************
        ADD ALL NODES
        *************/
        let entities = LevelFactory.getEntities(2, ipadIndex: ipadNr, scene: self)
        obstacles = (entities?.obstacles)!
        buttons = (entities?.buttons)!
        characters = (entities?.characters)!
        portals = (entities?.portals)!
        
        for o in obstacles {
            o.node.position = self.convertPointToView(o.position)
            self.scene!.addChild(o.node)
        }
        for b in buttons {
            b.node.position = self.convertPointToView(b.position)
            self.scene!.addChild(b.node)
            //add self as button listener
            b.listeners.append(self)
            //b.state =  ButtonState.NOT_PRESSED
        }
        for c in characters {
            c.node.position = self.convertPointToView(c.position)
            self.scene!.addChild(c.node)
            debugPrint("character: \(c.name)")
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
        //get name of other node, if any
        if let name = otherNode.name {
            //is other node a button
            if let button = getButtonByName(name) {
                if button.state != .PRESSED_RIGHT_COLOR {
                    button.state = (character.color === button.color) ? .PRESSED_RIGHT_COLOR : .PRESSED_WRONG_COLOR
                }
                button.visitors = button.visitors + 1
            } else if let portal = getPortalByName(name) where portal.isActive {
                if let colorStr : ColorString = ColorManager.getColorString(character.color)! {
                    fireGameEvent(.sendCharacter(characterColor: colorStr, portalColor: ColorManager.getColorString(portal.color)!))
                                            self.removeCharacter(character)
                    characterNode.runAction(fadeOut, completion: {

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
        let A = contact.bodyA.node!
        let B = contact.bodyB.node!
        
        if let name = A.name { //get name of node A, if any
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
        //get name of other node, if any
        if let name = otherNode.name {
            //is other node a button
            if let button = getButtonByName(name) {
                button.visitors = button.visitors - 1
                if button.visitors == 0{
                    button.state = .NOT_PRESSED
                    for listener in button.listeners {
                        listener.onButtonStateChange(button)
                    }
                }
                    //Assuming that there is only one player of each color
                else if character.color == button.color{
                    button.state = .PRESSED_WRONG_COLOR
                }
            } else if let portal = getPortalByName(name){
                portal.isActive = true //activate portal when character leaves portal
            }
        }
    }
    
    //resets level
    func reset() {
        scene!.removeAllChildren()
        characters = [Character]()
        movingCharacter = nil
        obstacles = [Obstacle]()
        buttons = [Button]()
        //initGameScene()
    }
    
    //checks if win condition i met
    func isWinning(){
        var winning = true
        for button in buttons {
            if(button.state != ButtonState.PRESSED_RIGHT_COLOR){
                winning = false
                break
            }
        }
        winConditions[ipadNr] = winning
        fireGameEvent(.winning(winning: winning, ipadNr: ipadNr))
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
                //move a player?
                if let character = getCharacterByName(name) {
                    movingCharacter = character
                    touchedNode.runAction(scaleUp) //
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
        newCharacter.node.alpha = 0
        newCharacter.node.position = self.convertPointToView(newCharacter.position)
        // add to characters....
        characters.append(newCharacter)
        // add node to scene
        scene!.addChild(newCharacter.node)
        newCharacter.node.runAction(fadeIn)
    }
    
    func spawnCharacterOnPortal(characterColor: UIColor, portal: Portal){
        //deactivate portal
        portal.isActive = false
        // get position from portal
        let portalPos = portal.position
        // create character
        let newCharacter = Character(x: portalPos.x, y: portalPos.y, color: characterColor)
        // create node
        newCharacter.node.alpha = 0
        newCharacter.node.position = self.convertPointToView(newCharacter.position)
        // add to characters....
        characters.append(newCharacter)
        // add node to scene
        scene!.addChild(newCharacter.node)
        newCharacter.node.runAction(fadeIn)
    }
    
    // Game Event Listener
    func onGameEventOverNetwork(event: GameEvent) {
        debugPrint("recieved game event over network: \(GameEvent.toString(event))")
        switch event {
        case let .sendCharacter(characterColorStr, portalColorStr):
            let portalColor = ColorManager.colors[portalColorStr]!
            let characterColor = ColorManager.colors[characterColorStr]!
            let portal = findPortalByColor(portalColor)
            if portal != nil {
                spawnCharacterOnPortal(characterColor, portal: portal!)
            }
            //spawnCharacter(ColorManager.colors[characterColor]!)
            break
        case let .openDoor(color):
            let door = findDoorByColor(ColorManager.colors[color]!)
            door?.isActive = false
            break
        case let .closeDoor(color):
            let door = findDoorByColor(ColorManager.colors[color]!)
            door?.isActive = true
        case let .winning(winning: winning, ipadNr: ipadNr):
            debugPrint("snopp snopparna")
                winConditions[ipadNr] = winning
                break
        default: break
        }
    }
    
    func onInGameEvent(event: GameEvent) {
        //handle more events later
        debugPrint("recieved in game event: \(GameEvent.toString(event))")
        switch event {
        case .sendCharacter(_, _):
            //do nothing, dont want to spawn to characters of same color :P
            break
        case let .openDoor(color):
            let door = findDoorByColor(ColorManager.colors[color]!)
            door?.isActive = false
            break
        case let .closeDoor(color):
            let door = findDoorByColor(ColorManager.colors[color]!)
            door?.isActive = true
        default: break
        }
    }
    
    func findDoorByColor(color: UIColor) -> Obstacle? {
        for o in obstacles {
            if o.color == color {
                return o
            }
        }
        return nil
    }
    
    func findPortalByColor(color: UIColor) -> Portal? {
        for p in portals {
            if p.color == color {
                return p
            }
        }
        return nil
    }
    
    func addGameEventListener(listener : InGameEventListener){
        gameEventListeners.append(listener)
    }
    
    
    func fireGameEvent(event: GameEvent){
        debugPrint("firing game event: \(GameEvent.toString(event))")
        for listener in gameEventListeners {
            listener.onInGameEvent(event)
        }
    }
    //Button Listener
    func onButtonStateChange(button: Button) {
        debugPrint("\(button.name) has a new state: \(button.state)")
        switch button.state {
        case ButtonState.NOT_PRESSED:
        fireGameEvent(GameEvent.closeDoor(doorColor: ColorManager.getColorString(button.color)!))
            break
        case ButtonState.PRESSED_RIGHT_COLOR, ButtonState.PRESSED_WRONG_COLOR:
        fireGameEvent(GameEvent.openDoor(doorColor: ColorManager.getColorString(button.color)!))
            break
        }
        isWinning()
    }
    
    //Connection listener
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