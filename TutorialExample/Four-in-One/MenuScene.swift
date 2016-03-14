//
//  MenuScene.swift
//  Four-in-One
//
//  Created by Alexander on 14/03/16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import Foundation
import SpriteKit


class MenuScene: SKScene {
    
    var tutorialTextNode: SKLabelNode!
    var gvc: GameViewController?
    
    override func didMoveToView(view: SKView){
        tutorialTextNode = SKLabelNode(fontNamed: "SanFransisco")
        tutorialTextNode!.text = "Tutorial"
        tutorialTextNode!.fontSize = 65
        tutorialTextNode!.fontColor = UIColor.blackColor()
        tutorialTextNode!.position = CGPointMake(CGRectGetMidX(self.view!.bounds),CGRectGetMidY(self.view!.bounds));
        debugPrint("didMoveToView")
        self.backgroundColor = UIColor.whiteColor()
        self.addChild(tutorialTextNode)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            //get touch location and touched node
            let location = touch.locationInNode(scene!)
            let touchedNode = scene!.nodeAtPoint(location)
            
            if(touchedNode == tutorialTextNode){
                //got to tutorial if gvc exists
                if (gvc != nil) {
                    gvc!.goToTutorial(1)
                }
            }
        
        }
    }
}
