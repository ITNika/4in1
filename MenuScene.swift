//
//  GameScene.swift
//  4in1
//
//  Created by Amanda Belfrage on 25/02/16.
//  Copyright (c) 2016 Amanda Belfrage. All rights reserved.
//

import SpriteKit
import Foundation

class MenuScene: SKScene {
    
    var titleLabel : SKLabelNode!   //Skapar nya noder
    var newGameLabel : SKLabelNode!
    var joinGameLabel : SKLabelNode!
    var settingsLabel : SKLabelNode!
    var tutorialLabel : SKLabelNode!
    var gvc: GameViewController?
    
    
    override func didMoveToView(view: SKView) {
        
        titleLabel = SKLabelNode(fontNamed: "ChalkboardSE-bold")     //Set font
        newGameLabel = SKLabelNode(fontNamed: "ChalkdboardSE-Regular")
        joinGameLabel = SKLabelNode(fontNamed: "ChalkboardSE-Regular")
        tutorialLabel = SKLabelNode(fontNamed: "ChalkboardSE-Regular")
        settingsLabel = SKLabelNode(fontNamed: "ChalkboardSE-Regular")
        
        titleLabel!.fontSize = 38              //Set size
        newGameLabel!.fontSize = 28
        joinGameLabel!.fontSize = 28
        tutorialLabel!.fontSize = 28
        settingsLabel!.fontSize = 28
        
        titleLabel!.fontColor = UIColor.orangeColor()      //Set color
        newGameLabel!.fontColor = UIColor.orangeColor()
        joinGameLabel!.fontColor = UIColor.orangeColor()
        tutorialLabel!.fontColor = UIColor.orangeColor()
        settingsLabel!.fontColor = UIColor.orangeColor()
        
        titleLabel!.text = "Fyra-i-ett Spel"      //Set name om the nodes that shows on screen
        newGameLabel!.text = "Skapa nytt spel"
        joinGameLabel!.text = "Gå med i ett spel"
        tutorialLabel!.text = "Öva själv"
        settingsLabel!.text = "Inställningar"
        
        titleLabel!.name = "title"             //Set name that calls the node
        newGameLabel!.name = "new"
        joinGameLabel!.name = "join"
        tutorialLabel!.name = "tutorial"
        settingsLabel!.name = "set"
        
        titleLabel!.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y:CGRectGetMidY(self.scene!.frame) + newGameLabel!.frame.height + 100)    //Set position
        newGameLabel!.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y:CGRectGetMidY(self.scene!.frame))
        joinGameLabel!.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: CGRectGetMidY(self.scene!.frame) - newGameLabel!.frame.height - 20)
        tutorialLabel!.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: CGRectGetMidY(self.scene!.frame) - newGameLabel!.frame.height - joinGameLabel!.frame.height - 40)
        settingsLabel!.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y:CGRectGetMidY(self.scene!.frame) - newGameLabel!.frame.height - joinGameLabel!.frame.height - tutorialLabel!.frame.height - 60)
        
        self.backgroundColor = UIColor.cyanColor()
        
        self.addChild(self.titleLabel!)     //Add nodes on screen
        self.addChild(self.newGameLabel!)
        self.addChild(self.joinGameLabel!)
        self.addChild(self.tutorialLabel!)
        self.addChild(self.settingsLabel!)
        
        
    }
  
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        self.menuHelper(touches)
        
    }

    
    func menuHelper(touches: Set<UITouch>) {
        for touch in touches {
            //let location = touch.locationInNode(scene!)
            //let touchedNode = scene!.nodeAtPoint(location)
            
            let touchedNode = self.nodeAtPoint(touch.locationInNode(self))
            
            if touchedNode.name == "title" {
                print("Title Label Pressed")
            }
            else if touchedNode.name == "new" {
                print("New game Label Pressed")
                //go to new game if gvc exists
                if (gvc != nil){
                      gvc!.goToGame()
                }
                
            }else if touchedNode.name == "join"{
                print("Join Label pressed")
                
            }else if touchedNode.name == "tutorial"{
                print("Tutorial Label pressed")
                
            }else if touchedNode.name == "set"{
                print("Settings Label pressed")
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    
}