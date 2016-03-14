//
//  Tutorial_1.swift
//  Four-in-One
//
//  Created by Alexander on 14/03/16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import Foundation
import UIKit

class Tutorial_1: GameScene {
    let number = 1
    
    override func initGameScene(){
        let offset: CGFloat = 150
        
        /********************************
         COLORS
         ********************************/
         
        // create some colors
        let blue = UIColor.blueColor()

        
        /********************************
         BUTTONS
         ********************************/
         
         // create blue button
        let blueButton = Button(x: self.view!.frame.width - offset, y: CGRectGetMidY(self.view!.bounds), color: blue)

        
        //create blue node
        let blueButtonNode = createShapeNodeFromModel(blueButton)!

        
        //add blue button to scene
        scene!.addChild(blueButtonNode)
        
        //add blue  button to buttons
        buttons[blueButtonNode.name!] = blueButton
        
        /********************************
         PLAYERS
         ********************************/

         // create players
        let bluePlayer = Player(x: offset, y: CGRectGetMidY(self.view!.bounds), color: blue)
        
        // create player Nodes
        let bluePlayerNode = createShapeNodeFromModel(bluePlayer)!
        
        // add player node to scene
        scene!.addChild(bluePlayerNode)
        
        // add to players....
        players[bluePlayerNode.name!] = bluePlayer
        
    }
    
    override func gameOver(){
        debugPrint("tut1")
        //reset()
        if gvc != nil {
            gvc!.goToTutorial(number + 1)
        }
    }

}