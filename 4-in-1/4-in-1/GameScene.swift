//
//  GameScene.swift
//  4-in-1
//
//  Created by Alexander on 17/03/16.
//  Copyright (c) 2016 Chalmers. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var characters = [Character]()
    var movingCharacter: Character?
    let enf = EntityNodeFactory()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //create charcter model
        let blue = UIColor.blueColor()
        let red = UIColor.redColor()
        
        let middleOfTheScreen: CGPoint = CGPointMake(CGRectGetMidX(self.view!.bounds), CGRectGetMidY(self.view!.bounds))
        let blueCharacter = Character(x: middleOfTheScreen.x, y: middleOfTheScreen.y, color: blue)
        let redCharacter = Character(x: middleOfTheScreen.x - 300, y: middleOfTheScreen.y, color: red)
        characters.append(blueCharacter)
        characters.append(redCharacter)
        
        //add character node
        let characterNode = enf.createShapeNodeFromModel(blueCharacter, scene: self)
        let characterNode2 = enf.createShapeNodeFromModel(redCharacter, scene: self)
        //add node to scene
        self.addChild(characterNode!)
        self.addChild(characterNode2!)
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
            
            if movingCharacter != nil {
                let newPosition = self.convertPointFromView(location)
                debugPrint("\(newPosition)")
                let oldPosition = movingCharacter!.position
                let deltaX = newPosition.x - oldPosition.x
                let deltaY = newPosition.y - oldPosition.y
                let distance = hypot(deltaX, deltaY);
                
                let maxDistance: CGFloat = 150
                if(distance <= maxDistance){
                    movingCharacter!.position = newPosition
                    debugPrint("\(movingCharacter?.name) moved to \(newPosition)")
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
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        //update character nodes
        for c in characters {
            if let node = self.childNodeWithName(c.name) {
                node.position = self.convertPointToView(c.position)
            }
        }
    }
}
