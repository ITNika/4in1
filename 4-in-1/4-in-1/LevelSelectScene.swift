//
//  LevelSelectScene.swift
//  4-in-1
//
//  Created by Lisa Lipkin on 05/05/16.
//  Copyright © 2016 Chalmers. All rights reserved.
//

import Foundation
import SpriteKit
import MultipeerConnectivity

class LevelSelectScene: SKScene, Scene, ConnectionListener {
    
    var selectLevelLabel : SKLabelNode?
    var texture: SKTexture?
    var gvc : GameViewController?
    var cm : ConnectivityManager?
    var levels : [(level: Int, status: String)]=[]
    let fontSmall : CGFloat = 28
    let fontBig : CGFloat  = 38
    
    
    override func didMoveToView(view: SKView) {
        debugPrint("moving to menu scene")
        // start hosting?
        cm?.startHosting()
        
        self.titleLabel = SKLabelNode(fontNamed: "ChalkboardSE-bold")     //Sätter typsnitt på texten
       
        
        self.titleLabel!.fontSize = fontBig             //Sätter storleken på de texten

        
        self.titleLabel!.fontColor = UIColor.orangeColor()      //Sätter färg på texten
 
        
        self.titleLabel!.text = "Välj nivå"      //Sätter namn på de olika noderna som syns på skärmen
        
        self.titleLabel!.name = "title"             //Skapar ett namn för att kalla på noderna. (Används när någon trycker på en knapp)
      
        
        self.titleLabel!.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y:CGRectGetMidY(self.scene!.frame) + newGameLabel!.frame.height + 100)    //Sätter position för noderna
   
        
        self.addChild(self.titleLabel!)  //Lägger till noderna på skärmen
        
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
