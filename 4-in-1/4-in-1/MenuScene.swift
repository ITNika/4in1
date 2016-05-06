//
//  GameScene.swift
//  4in1
//
//  Created by Amanda Belfrage on 25/02/16.
//  Copyright (c) 2016 Amanda Belfrage. All rights reserved.
//

import SpriteKit
import MultipeerConnectivity

class MenuScene: SKScene, Scene, ConnectionListener {
    
    var titleLabel : SKLabelNode?   //Skapar nya noder
    var newGameLabel : SKLabelNode?
    var joinGameLabel : SKLabelNode?
    var settingsLabel : SKLabelNode?
    var tutorialLabel : SKLabelNode?
    var texture: SKTexture?
    var gvc : GameViewController?
    var cm : ConnectivityManager?
    let fontSmall : CGFloat = 28
    let fontBig : CGFloat  = 38
    
    override func didMoveToView(view: SKView) {
        debugPrint("moving to menu scene")
        // start hosting?
        cm?.startHosting()
        
        self.titleLabel = SKLabelNode(fontNamed: "ChalkboardSE-bold")     //Sätter typsnitt på texten
        self.newGameLabel = SKLabelNode(fontNamed: "ChalkboardSE-Regular")
        self.joinGameLabel = SKLabelNode(fontNamed: "ChalkboardSE-Regular")
        self.tutorialLabel = SKLabelNode(fontNamed: "ChalkboardSE-Regular")
        self.settingsLabel = SKLabelNode(fontNamed: "ChalkboardSE-Regular")
        
        self.titleLabel!.fontSize = fontBig             //Sätter storleken på de texten
        self.newGameLabel!.fontSize = fontSmall
        self.joinGameLabel!.fontSize = fontSmall
        self.tutorialLabel!.fontSize = fontSmall
        self.settingsLabel!.fontSize = fontSmall
        
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
        
        self.addChild(self.titleLabel!)  //Lägger till noderna på skärmen
        self.addChild(self.newGameLabel!)
        self.addChild(self.joinGameLabel!)
        self.addChild(self.tutorialLabel!)
        self.addChild(self.settingsLabel!)
        
        /*************
         particles
        **************/
        let path = NSBundle.mainBundle().pathForResource("particles", ofType: "sks")
        let particle = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
        
        particle.position = self.convertPointToView(CGPointMake(100,100))
        particle.targetNode = self.scene
        
        particle.particleColorSequence = nil;
        particle.particleColorBlendFactor = 1.0;
        particle.particleColor = ColorManager.colors[ColorString.purple]!;
        self.addChild(particle)
    
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.menuHelper(touches)
    }
    
    func menuHelper(touches: Set<UITouch>) {
        for touch in touches {
            let nodeAtTouch = self.nodeAtPoint(touch.locationInNode(self))
            if nodeAtTouch.name == "title" {
                print("Title Label Pressed")
            }else if nodeAtTouch.name == "new" {
                print("New game Label Pressed")
                cm?.joinSession()
            }else if nodeAtTouch.name == "tutorial"{
                print("Tutorial Label pressed")
                gvc?.goToTutorial()
            }else if nodeAtTouch.name == "set"{
                print("Settings Label pressed")
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    //Connection Listener
    /*
    func handleMessage(message: String){
        // do something?
    }*/
    
    func onConnectionStateChange(state : MCSessionState){
        switch(state) {
        case .NotConnected: self.view?.scene?.backgroundColor = UIColor.redColor()
            break
        case .Connecting: self.view?.scene?.backgroundColor = UIColor.blueColor()
            break
        case .Connected: self.view?.scene?.backgroundColor = UIColor.greenColor()
            break
        }
    }
    
    
}
