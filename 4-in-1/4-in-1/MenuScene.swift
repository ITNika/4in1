//
//  GameScene.swift
//  4in1
//
//  Created by Amanda Belfrage on 25/02/16.
//  Copyright (c) 2016 Amanda Belfrage. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var titleLabel : SKLabelNode?   //Skapar nya noder
    var newGameLabel : SKLabelNode?
    var joinGameLabel : SKLabelNode?
    var settingsLabel : SKLabelNode?
    var tutorialLabel : SKLabelNode?
    var texture: SKTexture?
    
    //let menuImage = SKSpriteNode(imageNamed: "mainbg.jpg")
    
    override func didMoveToView(view: SKView) {
        
        //menuImage.size.height = self.size.height
        //menuImage.size.width = self.size.width
        //menuImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        //self.addChild(menuImage)
        
        self.titleLabel = SKLabelNode(fontNamed: "ChalkboardSE-bold")     //Sätter typsnitt på texten
        self.newGameLabel = SKLabelNode(fontNamed: "ChalkdboardSE-Regular")
        self.joinGameLabel = SKLabelNode(fontNamed: "ChalkboardSE-Regular")
        self.tutorialLabel = SKLabelNode(fontNamed: "ChalkboardSE-Regular")
        self.settingsLabel = SKLabelNode(fontNamed: "ChalkboardSE-Regular")
        
        self.titleLabel!.fontSize = 38              //Sätter storleken på de texten
        self.newGameLabel!.fontSize = 28
        self.joinGameLabel!.fontSize = 28
        self.tutorialLabel!.fontSize = 28
        self.settingsLabel!.fontSize = 28
        
        self.titleLabel!.fontColor = UIColor.orangeColor()      //Sätter färg på texten
        self.newGameLabel!.fontColor = UIColor.orangeColor()
        self.joinGameLabel!.fontColor = UIColor.orangeColor()
        self.tutorialLabel!.fontColor = UIColor.orangeColor()
        self.settingsLabel!.fontColor = UIColor.orangeColor()
        
        self.titleLabel!.text = "Fyra-i-ett Spel"      //Sätter namn på de olika noderna som syns på skärmen
        self.newGameLabel!.text = "Skapa nytt spel"
        self.joinGameLabel!.text = "Gå med i ett spel"
        self.tutorialLabel!.text = "Öva själv"
        self.settingsLabel!.text = "Inställningar"
        
        self.titleLabel!.name = "title"             //Skapar ett namn för att kalla på noderna. (Används när någon trycker på en knapp)
        self.newGameLabel!.name = "new"
        self.joinGameLabel!.name = "join"
        self.tutorialLabel!.name = "tutorial"
        self.settingsLabel!.name = "set"
        
        self.titleLabel!.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y:CGRectGetMidY(self.scene!.frame) + newGameLabel!.frame.height + 100)    //Sätter position för noderna
        self.newGameLabel!.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y:CGRectGetMidY(self.scene!.frame))
        self.joinGameLabel!.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: CGRectGetMidY(self.scene!.frame) - newGameLabel!.frame.height - 20)
        self.tutorialLabel!.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: CGRectGetMidY(self.scene!.frame) - newGameLabel!.frame.height - joinGameLabel!.frame.height - 40)
        self.settingsLabel!.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y:CGRectGetMidY(self.scene!.frame) - newGameLabel!.frame.height - joinGameLabel!.frame.height - tutorialLabel!.frame.height - 60)
        
        self.addChild(self.titleLabel!)     //Lägger till noderna på skärmen
        self.addChild(self.newGameLabel!)
        self.addChild(self.joinGameLabel!)
        self.addChild(self.tutorialLabel!)
        self.addChild(self.settingsLabel!)
        
        
        //GameScene = self
        // setupLayers()
        
        //        /* Setup your scene here */
        //        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        //        myLabel.text = "Hello, World!"
        //        myLabel.fontSize = 45
        //        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        //
        //        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        self.menuHelper(touches)
        
        //for touch in touches {
        //let location = touch.locationInNode(self)
        
        //let sprite = SKSpriteNode(imageNamed:"Spaceship")
        
        //sprite.xScale = 0.5
        //sprite.yScale = 0.5
        //sprite.position = location
        
        //let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        
        //sprite.runAction(SKAction.repeatActionForever(action))
        
        //self.addChild(sprite)
        //}
        
        
    }
    
    func menuHelper(touches: Set<UITouch>) {
        for touch in touches {
            let nodeAtTouch = self.nodeAtPoint(touch.locationInNode(self))
            if nodeAtTouch.name == "title" {
                print("Title Label Pressed")
            }else if nodeAtTouch.name == "new" {
                print("New game Label Pressed")
            }else if nodeAtTouch.name == "join"{
                print("Join Label pressed")
            }else if nodeAtTouch.name == "tutorial"{
                print("Tutorial Label pressed")
            }else if nodeAtTouch.name == "set"{
                print("Settings Label pressed")
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    
}
